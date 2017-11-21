class AddRadicalToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :radical, :boolean, null: false, default: false
    
    reversible do |d|
      d.up do
        execute "UPDATE accounts SET radical = true WHERE LENGTH(number) <= 3 AND usages IN ('capitals', 'expenses', 'finances', 'financial_year_result', 'fixed_assets', 'stocks', 'third_party', 'revenues')"
      end
    end
    
  end
end
