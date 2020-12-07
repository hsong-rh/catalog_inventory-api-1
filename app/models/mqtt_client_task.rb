class MqttClientTask < Task

  def initialize(payload)
    super
    @payload = payload
    @input = payload.to_json
  end

  def dispatch
  end
end
