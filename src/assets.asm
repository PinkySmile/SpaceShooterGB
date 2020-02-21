SECTION "Assets", ROMX[$7000], BANK[1]

; The fonts used.
textAssets::
 	incbin "assets/font.cfx"
textAssetsEnd::

; The space ship asset used.
spaceship::
 	incbin "assets/spaceship.fx"
spaceshipEnd::

; The space ship asset used.
asteroids::
 	incbin "assets/asteroids.fx"
asteroidsEnd::

; The background asset used.
background::
 	incbin "assets/background.cfx"
backgroundEnd::

; The background asset used.
laserSprite::
 	incbin "assets/laser.cfx"
 	incbin "assets/laser.cfx"
laserSpriteEnd::
