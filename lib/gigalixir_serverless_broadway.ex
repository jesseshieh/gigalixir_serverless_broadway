defmodule GigalixirServerlessBroadway do
  # We basically ask the user to provide everything below except
  # some boilerplate, the mix project, and the deployment
  # is that enough of a benefit for people to use?
  # are the drawbacks too high? (dependencies needed)
  use Broadway
  require Logger

  alias Broadway.Message

  def start_link(_opts) do
    Logger.debug "starting GigalixirServerlessBroadway"
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producers: [
        # i guess we preinstall a bunch of producers and you
        # select which one and provide us necessary configs
        # how to provide custom producers?
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
        # we can manage the number of stages for you
        # of course, you can override the settings if needed.
        default: [stages: 1]
      ],
      batchers: [
        # you tell us what stages you want and we'll manage the stages , batch_size and batch_timeout
        # of course, you can override the settings if needed.
        print: [stages: 1, batch_size: 10, batch_timeout: 1000]
      ]
    )
  end

  # you provied the handle_message function and we just plop it here.
  # how do they specify if they need certain dependencies in their mix.exs file?
  def handle_message(_processor_name, message, _context) do
    message
    |> Message.update_data(&process_data/1)
    |> Message.put_batcher(:print)
  end

  # you provied the handle_batch function(s) and we just plop it here.
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
