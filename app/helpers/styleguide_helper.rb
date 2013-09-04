module StyleguideHelper

  def cards_stub
    [
      {
        kind: "ad_sense",
        slug: "#",
        double: "false",
        title: "Hello"
      },
      {
        kind: "need_to_know",
        slug: "#",
        double: "false",
        title: "Hello",
        links: [
          {
            url: "/",
            title: "Item"
          },
          {
            url: "/",
            title: "Item"
          }
        ]
      },
      {
        kind: "double_image",
        cards: [
          {
            slug: "#",
            double: "false",
            resized_image_url: ""
          },
          {
            slug: "#",
            double: "false",
            resized_image_url: ""
          }
        ]
      }
    ]
  end

  def ad_config
    {hints: "", channels: ""}
  end

end