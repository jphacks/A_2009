module ApplicationHelper
  def qrcode_tag(text, options = {})
    ::RQRCode::QRCode.new(text).as_svg(
      {
        offset: 0,
        color: '000',
        shape_rendering: 'crispEdges',
        module_size: 6,
        standalone: true
      }
    ).html_safe
  end
end
