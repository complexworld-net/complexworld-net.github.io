breed [magnets magnet]
breed [bobs bob]
breed [spots spot]

magnets-own [q]
bobs-own [state]

extensions [fetch]

patches-own [S MAXS]

globals [colors t dt ipatch placed? image m g dz K ticks? trials xxx yyy nn answered?]

to startup
  ca
  user-message "Inserire un id, quindi premere 'setup'."
  set answered? false
end

to setup
  ifelse id = "" [
    user-message "Inserire un id."
  ][
    init
    user-message "Premere 'trace' e scegliere il punto di inizio. Regolare la sbarra della velocità verso il massimo (se su browser) in alto in modo che le traiettorie vengano tracciate velocemente."
  ]
end

to init
  ca
  ; image has been obtained with these values
  set m 10; magnetic intensity
  set g 0.01; dumping
  set dz 0.2; distance from plane
  set K 0.01; elastic force
  set colors [red blue green]
  create-magnets 3 [
    set shape "circled"
    set size 2
    set q m ; could vary with magnets
    let r world-width / 3;
    let theta who * 360 / 3;
    setxy r * sin(theta) r * cos(theta)
    set color item who colors
  ]
  create-bobs 1 [
    set shape "circle"
    set size 1
    set color white
    set state (list xcor ycor 0 0);
    set hidden? true
  ]
  create-spots 1 [
    set shape "circle"
    set size 4
    set color [255 255 0 100]
    set hidden? true
  ]

  set dt 0.01
  set t 0
  reset-ticks
  set placed? false
  ; get image with
  ; show map  [a -> [pcolor] of a] sort patches
  set image [15 15 105 55 55 105 55 15 105 15 55 55 15 15 55 55 15 105 105 15 15 105 105 15 15 105 55 55 105 105 55 105 15 55 55 105 105 55 105 55 105 15 55 15 105 15 15 15 15 15 15 15 15 15 55 15 105 15 55 105 55 105 55 55 55 105 15 15 105 55 15 105 105 105 105 15 55 15 15 15 15 15 15 15 15 15 15 15 105 15 55 15 55 55 15 105 55 15 105 15 55 55 55 55 55 55 15 105 105 15 15 15 15 15 15 15 15 15 15 15 15 15 55 55 15 105 105 105 105 105 105 105 105 105 55 15 55 15 15 105 15 105 15 15 15 15 15 15 15 15 15 15 15 15 15 55 15 55 15 15 105 15 105 55 105 15 15 55 15 55 15 105 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 55 15 105 15 105 105 105 55 105 55 55 105 105 105 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 55 15 55 105 105 55 105 105 15 55 15 55 55 55 105 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 105 105 105 105 15 15 15 55 55 55 105 15 55 55 15 105 105 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 55 55 15 105 105 15 55 55 105 15 15 55 15 55 15 55 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 105 15 105 55 105 15 15 105 105 15 15 105 105 105 15 105 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 55 15 55 55 55 15 15 55 55 55 15 15 15 15 15 55 105 105 105 15 15 15 15 15 15 15 15 15 15 15 15 15 55 55 55 105 15 15 15 15 15 105 15 55 15 105 105 105 105 105 105 105 105 15 15 15 15 15 15 15 15 15 15 15 55 55 55 55 55 55 55 55 15 105 15 105 105 55 55 15 15 105 105 55 15 105 105 15 15 15 15 15 15 15 15 15 55 55 15 105 55 55 15 15 105 105 55 55 105 55 15 55 55 55 55 55 55 55 55 55 105 105 15 15 15 15 15 55 55 105 105 105 105 105 105 105 105 105 15 105 55 55 15 55 105 55 55 55 55 55 55 55 55 55 55 105 15 15 15 55 105 105 105 105 105 105 105 105 105 105 55 105 15 105 55 55 105 55 55 55 55 55 55 55 55 55 55 55 55 55 15 105 105 105 105 105 105 105 105 105 105 105 105 105 55 105 105 55 15 55 55 55 55 55 55 55 55 55 55 55 55 55 55 15 105 105 105 105 105 105 105 105 105 105 105 105 105 105 15 105 55 15 105 55 55 55 55 55 55 55 55 55 55 55 55 55 15 105 105 105 105 105 105 105 105 105 105 105 105 105 55 15 105 55 15 105 55 55 55 55 55 55 55 55 55 55 55 55 55 15 105 105 105 105 105 105 105 105 105 105 105 105 105 55 15 105 105 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 15 105 105 105 105 105 105 105 105 105 105 105 105 105 105 105 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 15 105 105 105 105 105 105 105 105 105 105 105 105 105 105 105 105 105 105 15 55 55 55 55 55 55 55 55 55 55 55 55 55 15 105 105 105 105 105 105 105 105 105 105 105 105 105 15 55 55 105 105 105 55 55 55 55 55 55 55 55 55 55 55 55 55 15 105 105 105 105 105 105 105 105 105 105 105 105 105 55 55 55 105 15 105 15 55 55 55 55 55 55 55 55 55 55 55 105 15 55 105 105 105 105 105 105 105 105 105 105 105 15 55 15 55 55 105 105 15 55 55 55 55 55 55 55 55 55 55 55 15 15 15 105 105 105 105 105 105 105 105 105 105 105 15 55 55 55 15 15 15 55 55 55 55 55 55 55 55 55 55 55 55 55 15 105 105 105 105 105 105 105 105 105 105 105 105 105 15 15 15 105 15 15 55 105 55 15 55 55 55 55 55 55 15 15 55 15 105 15 15 105 105 105 105 105 105 15 105 55 105 105 105 55 105 55 105 15 55 105 55 15 105 105 105 55 15 55 105 105 15 55 55 105 15 105 55 55 55 15 105 55 105 15 105 55 15 55 55 105 105 105 15 55 55 105 55 105 15 15 15 55 15 15 15 105 15 15 15 55 105 55 105 105 15 55 55 55 55 105 15 55 15 55 15 105 105 15 105 55 55 15 15 55 105 15 15 15 55 105 15 55 105 105 55 15 55 55 15 105 15 105 15 55 55 105 15 105 105 15 55 55 55 15 15 55 15 15 15 55 15 15 15 105 15 15 105 105 55 105 55 55 15 55 105 105 55 15 105 105 15 105 15 15 55 105 105 15 105 55 105 55 55 105 55 105 55 15 55 55 105 15 15 55 15 15 55 55 105]
  let ms [0 1 1 0 0 0 1 1 0 1 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 1 1 1 0 1 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 0 0 0 1 1 1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 1 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 1 1 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 0 0 1 0 1 1 0 0 1 1 0 1 0 0 0 0 0 0 0 0 0 1 0 1 1 0 0 1 1 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 1 1 0 1 1 0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 1 1 1 0 0 1 0 0 0 0 1 0 0 1 1 0 1 1 0 0 1 0 0 0 0 1 0 0 0 1 1 1 1 0 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 0 1 0 0 1 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 0 1 1 1 0 1 0 0 0 1 0 0 0 1 0 1 0 1 0 1 0 1 0 0 0 1 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 1 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 1 1 1 1 0 1 1 1 1 0 0 0 1 1 1 0 0 0 0 0 0]
  (foreach  sort patches ms [[a b] -> ask a [set MAXS b]])
  set trials 0
  set answered? false
  tick
end



to reveal ; image
  (foreach  sort patches image [[a b] -> ask a [set pcolor b]])
end

to spot-the-chaos
  ask one-of spots [
    set hidden? true
    setxy mouse-xcor mouse-ycor
  ]
  if mouse-down? [
    set xxx mouse-xcor
    set yyy mouse-ycor
    ask one-of spots [
      set nn sum [MAXS] of patches in-radius 2
    ]
    user-message (word "Hai spottato " nn " punti massimamente caotici.")
    record-answer
    stop
  ]
end


to record-answer
  let args (list
    ["submit" "Submit"]
    ["usp" "pp_url"]
    (list "entry.1571259630" id)
    (list "entry.36176846" (word precision xxx 3))
    (list "entry.2125687222" (word precision yyy 3))
    (list "entry.731512679" (word precision trials 3))
    (list "entry.1320206334" (word precision nn 3))
  )
  ;https://docs.google.com/forms/d/e/1FAIpQLSeGr7IOM8fPXmn6pFD--8Fs5AWantOPdJ64KegZ859IvgaqqQ/viewform?usp=pp_url&entry.1571259630=id&entry.36176846=xx&entry.2125687222=yy&entry.731512679=tr&entry.1320206334=nn
  let lnk "https://docs.google.com/forms/d/e/1FAIpQLSeGr7IOM8fPXmn6pFD--8Fs5AWantOPdJ64KegZ859IvgaqqQ/formResponse?"

  let ll reduce [[x y] -> (word x "&" y)] map [a -> reduce [[z w] -> (word z "=" w)] a] args
  if not answered? [
    fetch:url-async (word lnk ll) [->]
    set answered? true
  ]
end


to place-bob
   ask bobs [
      set hidden? false
      setxy mouse-xcor mouse-ycor
  ]
  if mouse-down? [
    clear-drawing
    ask bobs [
      set state (list xcor ycor 0 0)
      set ipatch patch-here
    ]
    set placed? true
    set trials trials + 1
  ]
end

to trace
  ifelse  not placed? [
    place-bob
    set ticks? false
  ][
    move
  ]
end

to move
  if not ticks? [
    reset-ticks
    set ticks? true
  ]
  let v2 0
  set t 0
  ask bobs [
    reach-next-state
    let x item 0 state
    let y item 1 state
    ifelse x > min-pxcor - 0.5 and x < max-pxcor + 0.5 and y > min-pycor - 0.5 and y < max-pycor + 0.5 [
      set hidden? false
      pd
      setxy x y
    ][
      set hidden? true
      pu
    ]
    set v2 (item 2 state) ^ 2 + (item 3 state) ^ 2
  ]
  set t t + dt
  ;show (word "v2 = " v2 " min=" (min [distance one-of bobs] of magnets))
  if v2 < 1e-2 and (min [distance one-of bobs] of magnets) < 1e-1 or ticks > 20000 [
    ask bobs [
      pu
      let c [color] of min-one-of magnets [distance myself]
      ask ipatch [
        set pcolor c
      ]
    ]
    set placed? false
    ;stop
  ]
  tick
end

to do-map
  set ipatch one-of patches with [pcolor = black]
  clear-drawing
  ask bobs [
    setxy [pxcor] of ipatch + (2 * random-float 1 - 1) * 0.001 [pycor] of ipatch + (2 * random-float 1 - 1) * 0.001
    set state (list xcor ycor 0 0)
  ]
  set placed? true
  set ticks? false
  while [placed? ][
    move
  ]
  if not any? patches with [pcolor = black][
    stop
  ]
end

to-report xlogx [a]
  report ifelse-value a = 0 [0][ a * ln(a)]
end


to max-entropy
  reveal
  ask patches [
    let n count patches in-radius 1
    let l map [c -> xlogx(count patches in-radius 1 with [pcolor = c] / n)] colors
    set S -1 * sum l
  ]
  ask patches [
    set pcolor ifelse-value S > .99 [white][black]
  ]
end


to reach-next-state
  set state (rk4 t state dt)
end



to-report df [t0 state0]
  let rx0 item 0 state0
  let ry0 item 1 state0
  let vx0 item 2 state0
  let vy0 item 3 state0
  let dx0 vx0
  let dy0 vy0
  let fx sum [q * (xcor - rx0) / ((xcor - rx0) ^ 2 + (ycor - ry0) ^ 2 + dz ^ 2) ^ (3 / 2)] of magnets
  let fy sum [q * (ycor - ry0) / ((xcor - rx0) ^ 2 + (ycor - ry0) ^ 2 + dz ^ 2) ^ (3 / 2)] of magnets
  let dvx (fx - g * vx0 - K * rx0)
  let dvy (fy - g * vy0 - K * ry0)
  report ( list dx0 dy0 dvx dvy )
end

; http://mathworld.wolfram.com/Runge-KuttaMethod.html

to-report rk4 [ tn state-n dtt ]
  let k1 map [ tt ->  dtt * tt ] (df tn state-n)
  let k2 map [ tt -> dtt * tt ] (df (tn + dtt / 2) (map [[tt xx] -> tt + xx / 2 ] state-n k1))
  let k3 map [ tt -> dtt * tt ] (df (tn + dtt / 2) (map [[tt xx] -> tt + xx / 2] state-n k2))
  let k4 map [ tt -> dtt * tt ] (df (tn + dtt)     (map [[tt xx] -> tt + xx] state-n k3))

  let fn+1 (map [[tt xx] -> tt  + xx] state-n (reduce [[tt xx] -> (map + tt xx)]
     (list
      (map [tt -> tt / 6] k1)
      (map [tt -> tt / 3] k2)
      (map [tt -> tt / 3] k3)
      (map [tt -> tt / 6] k4)
     )
    )
  )
  report fn+1
end
@#$#@#$#@
GRAPHICS-WINDOW
25
280
604
860
-1
-1
17.30303030303031
1
10
1
1
1
0
0
0
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
315
235
381
268
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

BUTTON
405
235
468
268
NIL
trace
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

TEXTBOX
25
15
770
236
Questa applicazione simula le traiettorie di un pendolo di ferro attratto da tre magneti, colorati di rosso, verde e blu. Premere il pulsante \"setup\" e successivamente il bottone \"trace\". E' adesso possibile spostare il pendolo con il mouse in un punto di partenza e lasciarlo andare. Alla fine si fermerà su un magnete e il punto di partenza verrà colorato con il colore del magnete di arrivo. L'obiettivo è quello di capire in quali zone sia più probabile che una piccola differenza iniziale porti a un magnete differente.  \n\nImpostare la velocità del modello ad un valore abbastanza alto in modo che l'animazione scorra velocemente. \n\nCome test di valutazione premere \"spot-the-chaos\" e piazzare il cerchio giallo sulla zona che si considera sia quella più sensibile alle condizioni iniziali.\n\n
14
0.0
1

BUTTON
495
235
625
268
NIL
spot-the-chaos
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

INPUTBOX
15
205
244
265
id
sfv
1
0
String

TEXTBOX
675
285
950
471
1) Fai partire il pendolo da vari punti sulla mappa in modo da capire quali sono le zone più sensibili alle condizioni iniziali utilizzando i comandi \"setup\" e \"trace\"\n\n2) Quando pront* premere il pulsante \"spot-the-chaos\".\n\n3) Piazza il cerchio sulla zona che si considera più sensibile alle condizioni iniziali.
14
0.0
1

@#$#@#$#@
## WHAT IS IT?

The model approximates the motion of a pendulum with an iron bob, attracted by three magnets. The goal is that of mapping the basin of attraction of each magnet, assigning to the initial location of bob the color of the magnet nearedr to the final position


## HOW IT WORKS

it integrated the following equations of motion

x'' = - g x' - K x + \sum_i m_i (x_i - x)/((x_i - x)^2 + (y_i - y) ^ 2 + z ^2) ^ (3/2) 
y'' = - g y' - K y + \sum_i m_i (x_i - x)/((x_i - x)^2 + (y_i - y) ^ 2 + z ^2) ^ (3/2) 

where x, y is the location of bob, x' y' is its velocity and x'', y'' its acceleration, m_i, x_i, y_i is the charge and position of magnets, z is the distance between the bob ad the plane. The mass of bob is one. The pendulum motion is approximated by an elastic force (small amplitide). 

## HOW TO USE IT

Select setup and then "go". Place the bib with the mouse and it will swing until end. It will assign the color of the magnet neared to its final position to the initial patch. 
Try to spot the location where there is the maximan sensitivity to a perutrbation in the initial position


## RELATED MODELS

ChaoticPendulum-SpotChaos

## CREDITS AND REFERENCES

Franco bagnoli and Alessio Focardi 2023
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

circled
false
0
Circle -1 true false 0 0 300
Circle -7500403 true true 15 15 270

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
1
@#$#@#$#@