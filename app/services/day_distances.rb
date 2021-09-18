module DayDistances
  def self.call(routes)
    routes.group_by_day(:created_at, format: "%-d %B").sum(:distance).reject do |k,v|
      if v.integer?
        v = 0
      end
    end
  end
end