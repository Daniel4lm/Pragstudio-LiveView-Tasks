defmodule PentoWeb.SurveyLive.RatingLive.Show do
  use Phoenix.Component
  use Phoenix.HTML

  alias PentoWeb.SurveyLive.RatingLive

  def wrapper(assigns) do
    ~H"""
      <div class="survey-component-container">
        <.heading products={@products} />
        <.list products={@products} current_user={@current_user}/>
      </div>
    """
  end

  defp ratings_complete?(products) do
    Enum.all?(products, fn product ->
      if rating = Enum.at(product.ratings, 0) do
        true
      else
        false
      end
    end)
  end

  def heading(assigns) do
    ~H"""
      <h2>
        Ratings
        <%= if ratings_complete?(@products), do: raw "&#x2611;" %>
      </h2>
    """
  end

  def list(assigns) do
    ~H"""
      <%= for {product, index} <- Enum.with_index(@products) do %>
        <%= if rating = List.first(product.ratings) do %>
          <.stars product={product} rating={rating}/>
        <% else %>
          <.live_component module={RatingLive.Form}
            id={"rating-form-#{product.id}"}
            product={product}
            product_index={index}
            current_user={@current_user}
          />
        <% end %>
      <% end %>
    """
  end

  def stars(assigns) do
    stars =
      filled_stars(assigns.rating.stars)
      |> Enum.concat(unfilled_stars(assigns.rating.stars))
      |> Enum.join(" ")

    ~H"""
      <div>
        <h4>
          <%= @product.name %>:<br/>
          <%= raw stars %>
        </h4>
      </div>
    """
  end

  def filled_stars(stars) do
    List.duplicate("&#x2605;", stars)
  end

  def unfilled_stars(stars) do
    List.duplicate("&#x2606;", 5 - stars)
  end
end
