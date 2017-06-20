class AddFriendlyIdToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :friendly_id, :string
    add_index :events, :friendly_id, :unique => true
    # （add_index是给字段加索引）
    # （重复校验，确保是独一无二的unique）

    #作为后加入的功能栏位，在此把旧数据一并替换
    Event.find_each do |e|
      e.update( :friendly_id => SecureRandom.uuid)
    end
  end
end
