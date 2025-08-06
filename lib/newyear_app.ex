defmodule NewyearApp do
  use Application


  def start(_type, _args) do
    main()
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def main do
    target = Timex.to_datetime({{2026, 1, 1}, {0, 0, 0}}, "Europe/Stockholm")
    now = Timex.now("Europe/Stockholm")
	today = Timex.to_date(now)
	yesterday = Timex.shift(now, days: -1)
    yesterday_date = Timex.to_date(yesterday)
	tomorrow = Timex.shift(now, days: +1)
    tomorrows_date = Timex.to_date(tomorrow)

    time_till = DateTime.diff(target, now)

    days = div(time_till, 86_400)
    hours = div(rem(time_till, 86_400), 3_600)
    minutes = div(rem(time_till, 3_600), 60)
    seconds = rem(time_till, 60)


    IO.puts("Dagens datum i Sverige: #{today}")
	IO.puts("Gårdagens datum i Sverige: #{yesterday_date}")
	IO.puts("Morgondagens datum i Sverige: #{tomorrows_date}")
    IO.puts("Time until the New Year: #{days} days, #{hours} hours, #{minutes} minutes, #{seconds} seconds.")
  end
end
