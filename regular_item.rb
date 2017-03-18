class RegularItem

  def initialize(item)
    @item = item
  end

  def update
    update_quality
    update_sell_in
  end

  def update_quality
    @item.quality = quality_after_this_day
  end

  def update_sell_in
    @item.sell_in -= 1
  end

  def quality_after_this_day
    @quality_after_this_day ||= [0, [@item.quality + delta_quality, 50].min].max
  end

  def delta_quality
    @delta_quality ||= bsearch
  end

  def ranges
    @ranges ||= [(-Float::INFINITY..0), (1..Float::INFINITY)]
  end

  def index
    (0...ranges.size).bsearch { |i| ranges[i].member?(@item.sell_in) }
  end

  def delta_quality_by_sell_in
    {0 => -2, 1 => -1}
  end

  def bsearch
    delta_quality_by_sell_in[index]
  end
end
