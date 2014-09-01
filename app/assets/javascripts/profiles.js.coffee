jQuery ->
  new PortraitCropper()

class PortraitCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 1
      setSelect: [50, 50, 300, 300]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#profile_crop_x').val(coords.x)
    $('#profile_crop_y').val(coords.y)
    $('#profile_crop_w').val(coords.w)
    $('#profile_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#preview').css
      width: Math.round(100/coords.w * $('#cropbox').width()) + 'px'
      height: Math.round(100/coords.h * $('#cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'
