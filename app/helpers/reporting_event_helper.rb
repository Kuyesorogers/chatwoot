module ReportingEventHelper
  def business_hours(inbox, from, to)
    return 0 unless inbox.working_hours_enabled?

    BusinessTime::Config.work_hours = inbox_working_hours(inbox.working_hours)

    # Use inbox timezone to change from & to values.
    from_in_inbox_timezone = from.in_time_zone(inbox.timezone).to_time
    to_in_inbox_timezone = to.in_time_zone(inbox.timezone).to_time
    from_in_inbox_timezone.business_time_until(to_in_inbox_timezone)
  end

  private

  def inbox_working_hours(working_hours)
    working_hours.each_with_object({}) do |working_hour, object|
      object[day(working_hour.day_of_week)] = working_hour_range(working_hour) unless working_hour.closed_all_day?
    end
  end

  def day(day_of_week)
    week_days = {
      0 => 'sun',
      1 => 'mon',
      2 => 'tue',
      3 => 'wed',
      4 => 'thu',
      5 => 'fri',
      6 => 'sat'
    }
    week_days[day_of_week]
  end

  def working_hour_range(working_hour)
    [format_time(working_hour.open_hour, working_hour.open_minutes), format_time(working_hour.close_hour, working_hour.close_minutes)]
  end

  def format_time(hour, minute)
    "#{hour}:#{minute}"
  end
end
