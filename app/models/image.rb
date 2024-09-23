class Image < ApplicationRecord
  belongs_to :blog_post, optional: true
  has_one_attached :file

  validates :file, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml', 'image/webp'], size: { less_than: 5.megabytes }
  validates :alt_text, presence: true

  after_commit :optimize_image, on: [:create, :update]

  def self.ransackable_attributes(auth_object = nil)
    ["alt_text", "blog_post_id", "created_at", "id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["blog_post", "file_attachment", "file_blob"]
  end

  private
  
  def optimize_image
    return unless file.attached?

    file.open do |tempfile|
      Rails.logger.info "Tempfile path: #{tempfile.path}"

      processed_image = ImageProcessing::MiniMagick
        .source(tempfile.path)
        .resize_to_limit(1600, nil)
        .convert("webp")
        .call

      # Save the processed image to a temporary file
      processed_image_path = Rails.root.join('tmp', "#{SecureRandom.hex}.webp")
      Rails.logger.info "Attempting to write processed image to: #{processed_image_path}"

      processed_image.write(processed_image_path.to_s)

      # Log the processed image path
      Rails.logger.info "Processed image path: #{processed_image_path}"

      # Ensure the file is written before attempting to attach it
      if File.exist?(processed_image_path)
        Rails.logger.info "Processed image exists at: #{processed_image_path}"

        # Attach the processed image back to the file
        file.attach(io: File.open(processed_image_path), filename: "#{file.filename.base}.webp", content_type: 'image/webp')

        # Log the attachment details
        Rails.logger.info "File attached: #{file.blob.filename} - #{file.blob.byte_size} bytes"

        # Clean up the temporary file
        File.delete(processed_image_path)
      else
        Rails.logger.error "Processed image not found at #{processed_image_path}"
      end
    rescue StandardError => e
      Rails.logger.error "Error processing image: #{e.message}"
    end
  end
end
