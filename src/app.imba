let def clamp(v, min, max)
  return min if v <= min
  return max if v >= max
  v

tag App
  def setup
    @tiles = []
    for i in [1..15]
      let col = (i - 1) % 4
      let row = Math.floor((i - 1) / 4)
      let x = 5 + 100 * col
      let y = 5 + 100 * row
      @tiles.push({x: x, y: y, tx: x, ty: y, value: i})
    @empty = {tx: 305, ty: 305}
    for i in [1..100]
      random_move

  def random_tile
    @tiles[Math.floor(Math.random() * 15)]

  def random_move
    while true
      let tile = random_tile
      continue unless can_be_moved(tile)
      let e = @empty
      @empty = {tx: tile:tx, ty: tile:ty}
      tile:tx = e:tx
      tile:ty = e:ty
      tile:x = tile:tx
      tile:y = tile:ty
      return

  def can_be_moved(tile)
    return false if tiles_moving
    Math.abs(tile:tx - @empty:tx) + Math.abs(tile:ty - @empty:ty) == 100

  def tiles_moving
    @tiles.some do |tile|
      (tile:tx != tile:x) || (tile:ty != tile:y)

  def tile_clicked(tile)
    return unless can_be_moved(tile)
    let target_x = @empty:tx
    let target_y = @empty:ty
    let previous_x = tile:tx
    let previous_y = tile:ty
    tile:tx = target_x
    tile:ty = target_y
    @empty = {tx: previous_x, ty: previous_y}

  def mount
    document.add-event-listener("keydown") do |event|
      handle_key(event)
      Imba.commit
    setInterval(&,10) do
      for tile in @tiles
        tile:x += clamp(tile:tx - tile:x, -10, 10)
        tile:y += clamp(tile:ty - tile:y, -10, 10)
        Imba.commit

  def handle_key(event)
    let stx
    let sty
    if event:key == "ArrowLeft"
      stx = @empty:tx + 100
      sty = @empty:ty
    else if event:key == "ArrowRight"
      stx = @empty:tx - 100
      sty = @empty:ty
    else if event:key == "ArrowUp"
      stx = @empty:tx
      sty = @empty:ty + 100
    else if event:key == "ArrowDown"
      stx = @empty:tx
      sty = @empty:ty - 100
    else
      return
    let tile_to_move = @tiles.find do |tile|
      tile:tx == stx && tile:ty == sty
    if tile_to_move
      tile_clicked(tile_to_move)

    # tile_clicked(tile_to_move)

  def render
    <self>
      <header>
        "15 Puzzle"
      <.board>
        for tile in @tiles
          <.tile css:top=tile:y css:left=tile:x .active=can_be_moved(tile) :tap=(do tile_clicked(tile))>
            tile:value
      <.help>
        "Click on tiles to move, or use arrow keys."

Imba.mount <App>
