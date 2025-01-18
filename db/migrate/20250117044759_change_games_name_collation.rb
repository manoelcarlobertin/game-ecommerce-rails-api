class ChangeGamesNameCollation < ActiveRecord::Migration[6.0]
  def change
    execute <<~SQL
      PRAGMA writable_schema = 1;
      UPDATE sqlite_master SET sql = replace(sql, 'TEXT', 'TEXT COLLATE NOCASE')
      WHERE name = 'games' AND type = 'table';
      PRAGMA writable_schema = 0;
      VACUUM;
    SQL
  end
end
