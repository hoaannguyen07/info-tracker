class ChangePlayersPlayedToLosses < ActiveRecord::Migration[6.1]
  def change
    rename_column :players, :played, :losses
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
