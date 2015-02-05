class Photo < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  has_attached_file :file,
                    styles: {
                      medium: '300x300>',
                       small: '100x100>'
                    },
                    preserve_files: true,
                    default_url: "/images/missing.png"

  validates_attachment_content_type :file, content_type: /\Aimage\/.*\z/
end
