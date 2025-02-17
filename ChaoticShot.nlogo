breed [cannons cannon]
breed [bullets bullet]
breed [boxes box]

extensions [fetch]


globals [segments trials answered? responses score]
; segments are [p0 p1 type]
; where pi = [xi yi]
; and type: left top right bottom
;   <0: boundary
;   > 0: bounce on box

to startup
  user-message "Inserire un id, quindi premere 'setup'."
  set answered? false
end

to setup
  ifelse id = "" [
    user-message "Inserire un id."
  ][
    init
  ]
end

to init
  ca
  set trials 0
  set score 0
  reset-ticks
  let n 4
  while [n > 0] [
    let i 0
    while [i < n] [
      create-boxes 1 [
        set shape "rotsquare"
        set color green
        set size 2
        set heading 45
        setxy (i - (n - 1) / 2) * 6  (n ) * 4
      ]
      set i i + 1
    ]
    set n n - 1
  ]
  create-cannons 1 [
    set shape "doublecannon"
    set color red
    set size 6
    setxy 0 min-pycor + 6
  ]
  ; mark boundaries
  crt 1 [
    set size 0.5
    set shape "rotsquare"
    set heading 0
    set color blue
    setxy min-pxcor  min-pycor
    pd
    fd world-height - 1
    rt 90
    fd world-width - 1
    rt 90
    fd world-height - 1
    rt 90
    fd world-width - 1
    die
  ]
  ; mark target
  ask patches with [pycor = max-pycor and abs(pxcor) < 5] [
   set pcolor red
  ]
  set responses []
  set answered? false
  set-segments

end

to set-segments
  ; add boundaries to segments
  let p1 []
  let p2 []
  set segments []
  ; left
  set p1 (list (min-pxcor) (min-pycor ))
  set p2 (list (min-pxcor) (max-pycor))
  set segments fput (list  p1 p2 -1) segments
  ; top
  set p1 p2
  set p2 (list (max-pxcor) (max-pycor))
  set segments fput (list  p1 p2 -2) segments
  ; right
  set p1 p2
  set p2 (list (max-pxcor) (min-pycor))
  set segments fput (list  p1 p2 -3) segments
  ; bottom
  set p1 p2
  set p2 (list (min-pxcor) (min-pycor))
  set segments fput (list  p1 p2 -4) segments

  ask boxes [
    ; add boundaries to segments
    ;left
    set p1 (list (xcor + (sqrt(2) * size / 2) * sin(heading + 135))  (ycor + (sqrt(2) * size / 2) * cos(heading + 135)))
    set p2 (list (xcor + (sqrt(2) * size / 2) * sin(heading + 45))  (ycor + (sqrt(2) * size / 2) * cos(heading + 45)))
    set segments fput (list p1 p2 (who * 4 + 1)) segments
    ;top
    set p1 p2
    set p2 (list (xcor + (sqrt(2) * size / 2) * sin(heading - 45))  (ycor + (sqrt(2) * size / 2) * cos(heading - 45)))
    set segments fput (list p1 p2 (who * 4 + 2)) segments
    ;right
    set p1 p2
    set p2 (list (xcor + (sqrt(2) * size / 2) * sin(heading - 135))  (ycor + (sqrt(2) * size / 2) * cos(heading - 135)))
    set segments fput (list p1 p2 (who * 4 + 3)) segments
    ;bottom
    set p1 p2
    set p2 (list (xcor + (sqrt(2) * size / 2) * sin(heading + 135))  (ycor + (sqrt(2) * size / 2) * cos(heading + 135)))
    set segments fput (list p1 p2 (who * 4 + 4)) segments
  ]
end

to rotate-squares
  ask boxes [
    set heading random 360
  ]
  set-segments
end



to fire
  if (trials < 3) [
    ask cannons [
      facexy mouse-xcor mouse-ycor
    ]
    if mouse-down? and not any? bullets [
      ask one-of cannons [
        hatch-bullets 1 [
          set shape "circle"
          set color white
          set size .1 * [size] of myself
          set heading [heading] of myself
          set heading heading + 90
          fd .08 * [size] of myself
          set heading heading - 90
          pd
          trace
        ]
        hatch-bullets 1 [
          set shape "circle"
          set color white
          set size .1 * [size] of myself
          set heading [heading] of myself
          set heading heading + 90
          fd -.08 * [size] of myself
          set heading heading - 90
          pd
          trace
        ]
      ]
      set trials trials + 1
      output-print (word "tentativo n. " trials ": punteggio = " score)
      if trials = 3 [
        record-answer
      ]
      stop
    ]
  ]
end

to record-answer
  let args (list
    ["submit" "Submit"]
    ["usp" "pp_url"]
    (list "entry.1571259630" id)
    (list "entry.36176846" item 0 responses)
    (list "entry.2125687222" item 1 responses)
    (list "entry.731512679" item 2 responses)
  )
  ;https://docs.google.com/forms/d/e/1FAIpQLSeC2vGOSPpbxULi6l2BZdqBJmUyd_tAeKSvwW9wqrbXJY2cNQ/viewform?usp=pp_url&entry.1571259630=id&entry.36176846=111&entry.2125687222=222&entry.731512679=333
  let lnk "https://docs.google.com/forms/d/e/1FAIpQLSeC2vGOSPpbxULi6l2BZdqBJmUyd_tAeKSvwW9wqrbXJY2cNQ/formResponse?"

  let ll reduce [[x y] -> (word x "&" y)] map [a -> reduce [[z ww] -> (word z "=" ww)] a] args
  if not answered? [
    fetch:url-async (word lnk ll) [->]
    set answered? true
  ]
end


to trace
  let p0 0
  let cond true
  let l 0
  let i 0
  let q 0
  let p1 0
  let p2 0
  let t 0
  let c 0
  let alpha 0
  let a 0
  while [cond] [
    set p0 (list xcor ycor)
    set l (find-first-collision heading p0)
    set i item 0 l
    set q item i segments
    set p1 item 0 q
    set p2 item 1 q
    set t (item 2 q)
    set cond  t > 0 ; bounce on box
    set c item 1 l
    set a item 1 c
    setxy (xcor + a * sin(heading)) (ycor + a * cos(heading))
    set alpha atan ((item 0 p2) - (item 0 p1))  ((item 1 p2) - (item 1 p1))
    set heading 2 * alpha - heading
  ]
  stamp
  if [pcolor] of patch-here = red [
    set score score + 1
  ]
  die
end

to-report find-first-collision  [alpha p0]
  let i 0
  let aa 1000
  let ai -1
  let ac 0
  let c 0
  let k 0
  let a 0
  foreach segments [
    s -> set c (collision alpha p0 s)
    set k item 0 c
    set a item 1 c
    if k >= 0 and k <= 1 and a > 0.5 and a < aa [ ; 0.5: avoid double colision with the same segment
      set aa a
      set ai i
      set ac c
    ]
    set i i + 1
  ]
  report (list ai ac)
end




; given a segment defined by two point p1=[x1, y1] and p2 = [x2, y2]
; and a line defined by p0 = [x0, y0] and an angle alpha
; (i.e., a versor t = [tx, ty] = [sin(alpha), cos(alpha]) (in NetLogo)
; the intersection point is at
; p1 + k (p2 - p1) and p0 + a t
; i.e.
; k (p2-p1) - a t = p0 - p1
; (with 0 <= k <= 1)
; defining cross product x
; p x q = px qy - py qx
; we have
; k (p2-p1) x t  = (p0 - p1) x t => k =  (p0 - p1) x t / (p2-p1) x t
; -a t x (p2 - p1) = (p0 - p1) x (p2 - p1) => a = (p0 - p1) x (p2 - p1) / (p2 - p1) x t
; k = cross(p0-p1, t) / cross(p2-p1, t)
; a = cross(p0-p1, p2-p1) / cross(p2-p1, t)

to-report cross [p q]
  let px item 0 p
  let py item 1 p
  let qx item 0 q
  let qy item 1 q
  report px * qy - py * qx
end

; collision of a path starting from q0 heading alpha with segment s
; segment = [p1 p2]
to-report collision [alpha q0 s]
  let dp01 (map [[a b] -> a - b] q0 (item 0 s))
  let dp21 (map [[a b] -> a - b] (item 1 s) (item 0 s))
  let t (list sin(alpha) cos(alpha))
  let xx (cross dp21 t)
  let k ifelse-value xx != 0 [(cross dp01 t) / xx][-1]
  let a ifelse-value xx != 0 [(cross dp01 dp21) / xx][-1]
  report (list k a)
end
@#$#@#$#@
GRAPHICS-WINDOW
47
115
741
810
-1
-1
16.732
1
10
1
1
1
0
0
0
1
-20
20
-20
20
0
0
1
ticks
30.0

TEXTBOX
54
14
699
33
Ruotare i quadrati e quindi sparare (fire), cercando di massimizzare la distanza finale tra i proiettili
11
0.0
1

BUTTON
430
49
516
95
NIL
fire
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
300
49
417
93
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
54
40
284
100
id
asfa
1
0
String

OUTPUT
536
33
818
113
13

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

doublecannon
true
0
Circle -8630108 true false 75 75 150
Rectangle -7500403 true true 120 0 135 135
Rectangle -7500403 true true 165 0 180 135
Rectangle -7500403 true true 105 120 195 180

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

rotsquare
true
0
Rectangle -7500403 true true 0 0 300 300

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
