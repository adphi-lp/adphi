class AddAttachmentContentToReceipts < ActiveRecord::Migration
  def self.up
    change_table :receipts do |t|
      t.attachment :content
    end
  end

  def self.down
    remove_attachment :receipts, :content
  end
end
