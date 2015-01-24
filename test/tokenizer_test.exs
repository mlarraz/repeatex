defmodule TokenizerTest do
  use Amrita.Sweet
  alias Repeatex.Tokenizer, as: Tokenizer

  describe "days" do

    it "parses single day" do
      Tokenizer.days("every week on thursday")
        |> [:thursday]
    end

    it "parses sequential days" do
      Tokenizer.days("daily")
        |> [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]

      Tokenizer.days("every week on mon-sat")
        |> [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday]

      Tokenizer.days("every week on fri-sun")
        |> [:sunday, :friday, :saturday]

      Tokenizer.days("every week on fri-mon")
        |> [:sunday, :monday, :friday, :saturday]
    end

    it "parses month days" do
      Tokenizer.monthly_days("1st and 3rd every 2 months")
        |> [1, 3]

      Tokenizer.monthly_days("the 25th of every month")
        |> [25]
    end

    it "parses relative days of the month" do
      Tokenizer.monthly_days("1st monday and 3rd wednesday every 2 months")
        |> [{1, :monday}, {3, :wednesday}]

      # TODO: potentially change this behavior later
      Tokenizer.monthly_days("1st and 3rd mondays every 2 months")
        |> [1, {3, :monday}]
    end

    it "parses month and day for yearly repeat" do
      Tokenizer.yearly_days("Jan 1st and Feb 2nd of every other year")
        |> [january: 1, february: 2]

      Tokenizer.yearly_days("March 26 annually")
        |> [march: 26]
    end
  end

  it "determines the type of repeat" do
    Tokenizer.type("each week")              |> :weekly
    Tokenizer.type("mon-sat every week")     |> :weekly
    Tokenizer.type("every tues")             |> :weekly
    Tokenizer.type("thursdays")              |> :weekly
    Tokenizer.type("the 1st of every month") |> :monthly
    Tokenizer.type("Feb 29 every 4 years")   |> :yearly
    Tokenizer.type("invalid format")         |> :unknown
  end

  it "determines the frequency" do
    Tokenizer.frequency("daily")                           |> 1
    Tokenizer.frequency("annually")                        |> 1
    Tokenizer.frequency("wednesday")                       |> 1
    Tokenizer.frequency("every wednesday")                 |> 1
    Tokenizer.frequency("every other monday")              |> 2
    Tokenizer.frequency("thursdays bi-weekly")             |> 2
    Tokenizer.frequency("thursdays every other week")      |> 2
    Tokenizer.frequency("Feb 29 every 4 years")            |> 4
    Tokenizer.frequency("every 3rd thursday of the month") |> 1
    Tokenizer.frequency("invalid format")                  |> nil
  end

  describe "helpers" do

    it "finds sequential days" do
      Repeatex.Helper.seq_days(:monday, :wednesday)
        |> [:monday, :tuesday, :wednesday]

      Repeatex.Helper.seq_days(:friday, :monday)
        |> [:sunday, :monday, :friday, :saturday]
    end
  end

end
