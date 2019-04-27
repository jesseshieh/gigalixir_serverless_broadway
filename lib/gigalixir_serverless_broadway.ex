defmodule GigalixirServerlessBroadway do
  use Broadway
  require Logger

  alias Broadway.Message

  def start_link(_opts) do
    Logger.debug "starting GigalixirServerlessBroadway"
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producers: [
        sqs: [
          module:
            {BroadwaySQS.Producer,
             queue_name: "gigalixir-broadway-test",
             config: [
               access_key_id:
                 Application.get_env(
                   :gigalixir_serverless_broadway,
                   :aws_access_key_id
                 ),
               secret_access_key:
                 Application.get_env(
                   :gigalixir_serverless_broadway,
                   :aws_secret_access_key
                 )
             ]}
        ]
      ],
      processors: [
        default: [stages: 1]
      ],
      batchers: [
        print: [stages: 1, batch_size: 10, batch_timeout: 1000]
      ]
    )
  end

  def handle_message(_processor_name, message, _context) do
    message
    |> Message.update_data(&process_data/1)
    |> Message.put_batcher(:print)
  end

  def handle_batch(:print, messages, _batch_info, _context) do
    Logger.debug("batching: #{inspect(messages)}")

    Enum.each(messages, fn msg ->
      IO.puts(msg.data)
    end)

    messages
  end

  defp process_data(data) do
    Logger.debug("processing: #{inspect(data)}")
    data
  end
end
