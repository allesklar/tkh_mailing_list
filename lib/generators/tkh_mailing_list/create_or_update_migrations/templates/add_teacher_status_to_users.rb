class AddTeacherStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :teacher_status, :string
    add_index :users, :teacher_status
  end
end
