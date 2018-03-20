defmodule Kata do
  def part1(num) when is_number(num) do
    # all possible letters (copy pasted from the kata)
    letters = """
               _     _  _     _  _  _  _  _ 
              | |  | _| _||_||_ |_   ||_||_|
              |_|  ||_  _|  | _||_|  ||_| _|
              """
    # generate this big mapping of digit to rows of strings
    # %{
    #   "0" => [" _ ", "| |", "|_|"],
    #   "1" => ["   ", "  |", "  |"],
    #   "2" => [" _ ", " _|", "|_ "],
    #   "3" => [" _ ", " _|", " _|"],
    #   "4" => ["   ", "|_|", "  |"],
    #   "5" => [" _ ", "|_ ", " _|"],
    #   "6" => [" _ ", "|_ ", "|_|"],
    #   "7" => [" _ ", "  |", "  |"],
    #   "8" => [" _ ", "|_|", "|_|"],
    #   "9" => [" _ ", "|_|", " _|"]
    # }
    digit_slices = letters
                   |> String.split("\n")
                   |> Enum.reduce(Map.new(), fn (line, acc) ->
                     Map.merge(acc, chunk(line), fn _k, v0, v1 ->
                       v0 ++ v1
                     end)
                   end)
    # turn 123 into ["1", "2", "3"]
    digit_strings = num
                    |> to_string
                    |> String.codepoints
    # for each of the three rows
    for i <- 0..2 do
      # take our input digits
      digit_strings
      # get their LCD string representation for this row index
      |> Enum.map(fn digit ->
        digit_slices[digit]
        |> Enum.at(i)
      end)
      # concatenate all the string representations for this row
      |> Enum.join("")
    end
    # join all the rows with newlines
    |> Enum.join("\n")
    # print the final product to the console
    |> IO.puts
  end

  defp chunk(line) do
    # turn "foobarbaz" into ["foo", "bar", "baz"]
    # (turn a string in to a list of three character strings)
    (for <<chunk::binary-3 <- line>>, do: chunk)
    # generate a stream from the above with indexes
    |> Stream.with_index
    # reduce this list of 3 char strings into a map with
    # * string indexes as keywords
    # * a single element list containing one 3 char string
    # %{
    #   "0" => ["foo"],
    #   "1" => ["bar"],
    #   "2" => ["baz"],
    # }
    |> Enum.reduce(Map.new(), fn({chunk, index}, acc) ->
      Map.merge(acc, %{"#{index}" => [chunk]})
    end)
  end
end
