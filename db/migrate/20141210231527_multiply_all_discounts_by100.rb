class MultiplyAllDiscountsBy100 < ActiveRecord::Migration
  def up
  	StorageItem.all.each do |s|
  		if not s.discount.blank? and s.discount > 0
  			s.discount *= 100.0
  			s.save
  		end
  	end
  end

  def down
  	StorageItem.all.each do |s|
  		if not s.discount.blank? and s.discount > 0
  			s.discount /= 100.0
  			s.save
  		end
  	end
  end
end
