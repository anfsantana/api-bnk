defmodule ApiBnK.Utils.StatusResponse do

  def get_status_response_by_key(key) do
   map = %{ OK: %{ code: 200, message: "OK" },
      CREATED: %{ code: 201, message: "Created" },
      NO_CONTENT: %{ code: 204, message: "No Content"},
      UNPROCESSABLE_ENTITY: %{ code: 422, message: "Unprocessable Entity"},
      INTERNAL_SERVER_ERROR: %{ code: 500, message: "Internal Server Error"}}
   map[key]
  end
end
