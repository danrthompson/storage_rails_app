Analytics = Segment::Analytics.new({
  write_key: 'VTdXrhLwS6VEdOcqoQmismhzR7DNKVDH',
  on_error: Proc.new { |status, msg| print msg }
})