class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.string :name
      t.timestamps
    end
  end
end

class CreateAuthors < ActiveRecord::Migration[5.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.timestamps
    end
  end
end

class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :name
      t.integer :pages
      t.belongs_to :author, foreign_key: true
      t.belongs_to :borrower
      t.timestamps
    end

    add_foreign_key :books, :members, column: :borrower_id
  end
end

CreateMembers.migrate('up')
CreateAuthors.migrate('up')
CreateBooks.migrate('up')