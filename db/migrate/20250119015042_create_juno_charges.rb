class CreateJunoCharges < ActiveRecord::Migration[6.0]
  def change
    create_table :juno_charges do |t|
      t.string :charge_id
      t.decimal :amount, precision: 10, scale: 2
      t.string :status
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
