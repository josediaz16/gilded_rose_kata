class BackStagePassesItem < RegularItem
  def ranges
    @ranges ||= [(-Float::INFINITY..0), (1..5), (6..10), (11..Float::INFINITY)]
  end

  def index
    ranges.index { |range| range.member?(@item.sell_in) }
  end

  def delta_quality_by_sell_in
    { 0 => -@item.quality, 1 => 3, 2 => 2, 3 => 1}
  end
end
