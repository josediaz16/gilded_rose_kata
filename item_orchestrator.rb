require 'regular_item'
require 'aged_brie_item'
require 'sulfuras_item'
require 'backstage_passes_item'

module ItemOrchestrator
  def self.build_item(item)
    options = {
      'Aged Brie' =>  lambda { AgedBrieItem.new(item) },
      'Backstage passes to a TAFKAL80ETC concert' => lambda { BackStagePassesItem.new(item) },
      'Sulfuras, Hand of Ragnaros' => lambda { SulfurasItem.new(item) }
    }
    new_item = options[item.name] || regular_item(item)
    new_item.call
  end

  def self.regular_item(item)
    lambda { RegularItem.new(item) }
  end
end
