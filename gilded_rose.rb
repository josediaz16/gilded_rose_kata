AGED_BRIE = 'Aged Brie'
BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert"
SULFURAS = "Sulfuras, Hand of Ragnaros"

def update_quality(items)
  items.each do |item|
    do_something_if_name_not_matches(item, [AGED_BRIE, BACKSTAGE_PASSES],
      option1: decrease_quality_if_quality_bigger_than_zero_and_not_sulfuras(item),
      option2: increase_quality_if_bigger_than_50_and_modify_values_for_backstage(item)
    )
    do_something_if_name_not_matches(item, [SULFURAS], option1: decrease_value(item, :sell_in, 1))
    do_something_if_sell_in_smaller_than(item, 0, increse_or_decrease_quality_if_is_aged_or_not(item) )
  end
end

def increse_or_decrease_quality_if_is_aged_or_not(item)
  lambda do
    do_something_if_name_not_matches(item, [AGED_BRIE], option1: decrease_quality_for_not_backstage(item), option2: increase_quality_if_lower_than_50(item))
  end
end

def increase_quality_if_bigger_than_50_and_modify_values_for_backstage(item)
  increase_quality_if_lower_than_50(item) do
    do_something_if_name_not_matches(item, [BACKSTAGE_PASSES], option1: increase_quality_depending_on_sell_in(item), flag: true)
  end
end

def decrease_quality_for_not_backstage(item)
  lambda do
    do_something_if_name_not_matches(item, [BACKSTAGE_PASSES], option1: decrease_quality_by_one_if_not_sulfuras(item), option2: decrease_value(item, :quality, item.quality))
  end
end

def decrease_quality_if_quality_bigger_than_zero_and_not_sulfuras(item)
  lambda { do_something_if_quality_bigger(item, 0, decrease_quality_by_one_if_not_sulfuras(item)) }
end

def decrease_quality_by_one_if_not_sulfuras(item)
   lambda { do_something_if_name_not_matches(item, [SULFURAS], option1: decrease_value(item, :quality, 1)) }
end

def increase_quality_depending_on_sell_in(item)
  lambda do
    do_something_if_sell_in_smaller_than(item, 11, increase_quality_if_lower_than_50(item) )
    do_something_if_sell_in_smaller_than(item, 6, increase_quality_if_lower_than_50(item) )
  end
end

def name_matches?(item, *names)
  names.include?(item.name)
end

def quality_bigger_than?(item, value)
  item.quality > value
end

def quality_smaller_than?(item, value)
  item.quality < value
end

def sell_in_smaller_than?(item, value)
  item.sell_in < value
end

def do_something_if_name_not_matches(item, names, **args)
  flag = args[:flag] || false
  options = base_hash(args[:option1], args[:option2])
  options[(name_matches?(item, *names) == flag)].call
end

def do_something_if_quality_bigger(item, value, option1, option2 = nil)
  options = base_hash(option1, option2)
  options[(quality_bigger_than?(item, value))].call
end

def do_something_if_sell_in_smaller_than(item, value, option1, option2 = nil)
  options = base_hash(option1, option2)
  options[(sell_in_smaller_than?(item, value))].call
end

def increase_quality_if_lower_than_50(item, &block)
  options = base_hash(increase_quality_by_one(item, &block))
  options[quality_smaller_than?(item, 50)]
end

def increase_quality_by_one(item, &block)
  options = base_hash(lambda{yield})
  lambda do
    item.quality += 1
    options[block_given?].call
  end
end

def decrease_value(item, value, inc)
  lambda { item[value] -= inc }
end

def empty_block
  lambda { }
end

def base_hash(option1, option2 = nil)
  {
    true => option1,
    false => option2 || empty_block
  }
end


# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new(AGED_BRIE, 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new(SULFURAS, 0, 80),
#   Item.new(BACKSTAGE_PASSES, 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

