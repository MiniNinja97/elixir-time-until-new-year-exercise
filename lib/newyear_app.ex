defmodule NewyearApp do
  use Application

  def start(_type, _args) do
    august_dates = all_august_dates()
    html = render_html(august_dates)

    File.write!("output.html", html)
    IO.puts("html skapad som 'output.html', öppna i webbläsaren")

    Supervisor.start_link([], strategy: :one_for_one)
  end

  def main do
    target = Timex.to_datetime({{2026, 1, 1}, {0, 0, 0}}, "Europe/Stockholm")
    now = Timex.now("Europe/Stockholm")
    today = Timex.to_date(now)
    yesterday = Timex.to_date(Timex.shift(now, days: -1))
    tomorrow = Timex.to_date(Timex.shift(now, days: +1))

    time_till = DateTime.diff(target, now)

    days = div(time_till, 86_400)
    hours = div(rem(time_till, 86_400), 3_600)
    minutes = div(rem(time_till, 3_600), 60)
    seconds = rem(time_till, 60)

    IO.puts("Dagens datum i Sverige: #{today}")
    IO.puts("Gårdagens datum i Sverige: #{yesterday}")
    IO.puts("Morgondagens datum i Sverige: #{tomorrow}")

    countdown_text = "Dagar kvar tills nyår: #{days} dagar, #{hours} timmar, #{minutes} minuter, #{seconds} sekunder."
    IO.puts(countdown_text)

    countdown_text
  end

  def all_august_dates(year \\ 2025) do
    Enum.map(1..31, fn day ->
      {:ok, date} = Date.new(year, 8, day)
      date
    end)
  end

  def render_html(august_dates) do
    """
    <!DOCTYPE html>
    <html lang="sv">
    <head>
      <meta charset="UTF-8">
      <title>Nyårsnedräkning</title>
      <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-blue-50 p-8 font-sans">

      <div class="mb-10">
        <h1 class="text-3xl font-bold mb-2">Dagar kvar till nytt år</h1>
        <div class="text-xl text-gray-800">
          #{main()}
        </div>
      </div>

      <h1 class="text-3xl font-bold mb-6">Augusti månad</h1>

      <div class="grid grid-cols-7 gap-2 text-center">
        #{Enum.map(~w(Mån Tis Ons Tor Fre Lör Sön), fn day ->
          "<div class='font-semibold bg-blue-200 p-2 rounded'>#{day}</div>"
        end) |> Enum.join("")}

        #{Enum.map(august_dates, fn date ->
          weekday = Date.day_of_week(date)

          if date.day == 1 do
            List.duplicate("<div></div>", rem(weekday + 5, 7))
          else
            []
          end ++ ["<div class='day hover:bg-blue-700 cursor-pointer'>#{date.day}</div>"]
        end) |> List.flatten() |> Enum.join("")}
      </div>

    </body>
    </html>
    """
  end
end
