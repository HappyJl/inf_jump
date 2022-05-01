require daslib/media

let
    CUBE_COLOR      = 0xFF3F70
    GROUND_COLOR    = 0x504022
    SKY_COLOR       = 0xB0E0FF
    COLUMN_COLOR    = 0xff00ff
    JUMP_VELONCITY  = 1000.0
    MOVE_VELONCITY  = 1000.0

struct Cube
    position: float2
    velocity: float2
    move: float
    MoveState: float
    size: float
    accelerating: float
    JumpState: float

struct Platform
    posY: float
    posX: float
    width: float
    height: float

let panelList = [[auto[]
    [[Platform posY=700.0, posX=0.0, width=2000.0, height=25.0]];
    [[Platform posY=500.0, posX=500.0, width=200.0, height=25.0]]
]]

var
    camera_x = 0.0
    cube: Cube
    platform: Platform

def reset_cube(var c: Cube)
    c.position = float2(get_screen_width()/2)
    c.velocity = float2(0.0)
    c.accelerating = 0.0
    c.size = 15.0
    c.move = -PI
    c.JumpState = 0.0;

//------------------------------------------------------- move trash cube -----------------------------------------------------------------------
def wrap(var v: float2&)
    if v.x < 0.0
        v.x += float(get_screen_width())
    if v.x > float(get_screen_width())
        v.x -= float(get_screen_width())

def update_cube(var c: Cube; var p: Platform; dt:float)
    //c.position = c.position + c.velocity * dt
    //c.velocity.y += float(JUMP_VELONCITY) * dt
    //if c.position.y > float(get_screen_height()) - 50.0
        //c.position.y = float(get_screen_height()) - 50.0
    //if cube.position.y == float(get_screen_height()) - 50.0
        //cube.velocity.y = clamp(cube.velocity.y - 650.0, -650.0, -650.0)   
    //if  c.position.y - (c.size/2.0) < p.posY - (p.height/2.0)
        //cube.velocity.y = clamp(cube.velocity.y - 650.0, -650.0, -650.0)
    
    wrap(c.position)

//------------------------------------------------------- move trash cube -----------------------------------------------------------------------

//------------------------------------------------------- render some shit ----------------------------------------------------------------------
def render_cube(var c: Cube)
    let x = int(c.position.x - camera_x - c.size * 0.5)
    let y = int(c.position.y - c.size * 0.5)
    fill_rect(x, y, int(c.size), int(c.size), CUBE_COLOR)

def render_platform(p: Platform)
    fill_rect(p.posX, p.posY, p.width, p.height, GROUND_COLOR)

def render_background(t: float)
    fill_rect(0, 0, get_screen_width(), get_screen_height(), SKY_COLOR)

def render_ground()
    fill_rect(0, get_screen_height() - 50, get_screen_width(), 200, GROUND_COLOR)

//------------------------------------------------------- render some shit ---------------------------------------------------------------------- 

[export]
def initialize
    set_window_title("inf jump")
    reset_cube(cube)


def update_gameplay(dt: float)
    update_cube(cube, platform, dt)

[export]
def act(dt: float)
    if get_key(VK_ESCAPE)
        schedule_quit_game()
    // print("act dt={dt}\n")
    update_gameplay(dt)
    
    if get_key(VK_A) || get_key(VK_LEFT)
        cube.position.x -= MOVE_VELONCITY * dt
    if get_key(VK_D) || get_key(VK_RIGHT)
        cube.position.x += MOVE_VELONCITY * dt
   
[export]
def draw()
    render_background(camera_x)
    for panel in panelList
        render_platform(panel)
    render_cube(cube)