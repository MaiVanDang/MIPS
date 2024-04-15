.eqv HEADING 0xffff8010    # Integer: Góc giữa 0 và 359
                            # 0: Bắc (lên)
                            # 90: Đông (phải)
                            # 180: Nam (xuống)
                            # 270: Tây (trái)
.eqv MOVING 0xffff8050     # Boolean: có di chuyển hay không
.eqv TRACKING 0xffff8020   # Boolean (0 hoặc khác 0):
                            # có để lại dấu vết hay không
.eqv WHEREX 0xffff8030     # Integer: Vị trí x hiện tại của Marsbot
.eqv WHEREY 0xffff8040     # Integer: Vị trí y hiện tại của Marsbot
.eqv TRACK_CHAR '*'        # Ký tự để vẽ dấu vết

.text
main:
    jal TRACK               # Bắt đầu vẽ đường đi
    nop
    addi $a0, $zero, 90     # Marsbot quay 90 độ và bắt đầu di chuyển
    jal ROTATE
    nop
    jal GO                  # Bắt đầu di chuyển Marsbot
    nop
    sleep1:
        addi $v0, $zero, 32 # Tiếp tục di chuyển bằng cách ngủ trong 1000 ms
        li $a0, 1000
        syscall
        jal TRACK           # Vẽ đường đi mới
        nop
    goDOWN:
        addi $a0, $zero, 180    # Marsbot quay 180 độ
        jal ROTATE
        nop
    sleep2:
        addi $v0, $zero, 32     # Tiếp tục di chuyển bằng cách ngủ trong 2000 ms
        li $a0, 2000
        syscall
        jal TRACK               # Vẽ đường đi mới
        nop
    goLEFT:
        addi $a0, $zero, 270    # Marsbot quay 270 độ
        jal ROTATE
        nop
    sleep3:
        addi $v0, $zero, 32     # Tiếp tục di chuyển bằng cách ngủ trong 1000 ms
        li $a0, 1000
        syscall
        jal TRACK               # Vẽ đường đi mới
        nop
    goASKEW:
        addi $a0, $zero, 120    # Marsbot quay 120 độ
        jal ROTATE
        nop
    sleep4:
        addi $v0, $zero, 32     # Tiếp tục di chuyển bằng cách ngủ trong 2000 ms
        li $a0, 2000
        syscall
        jal TRACK               # Vẽ đường đi mới
        nop
end_main:

#-----------------------------------------------------------
# GO procedure, để bắt đầu di chuyển
# param[in] none
#-----------------------------------------------------------
GO:
    li $at, MOVING             # Thay đổi port MOVING
    addi $k0, $zero, 1         # thành logic 1,
    sb $k0, 0($at)             # để bắt đầu di chuyển
    nop
    jr $ra
    nop

#-----------------------------------------------------------
# STOP procedure, để dừng di chuyển
# param[in] none
#-----------------------------------------------------------
STOP:
    li $at, MOVING             # Thay đổi port MOVING thành 0
    sb $zero, 0($at)           # để dừng
    nop
    jr $ra
    nop

#-----------------------------------------------------------
# TRACK procedure, để bắt đầu vẽ đường đi
# param[in] none
#-----------------------------------------------------------
TRACK:
    li $at, TRACKING           # Thay đổi port TRACKING
    addi $k0, $zero, 1         # thành logic 1,
    sb $k0, 0($at)           # để bắt đầu vẽ đường đi
    nop
    jr $ra
    nop

#-----------------------------------------------------------
# UNTRACK procedure, để ngừng vẽ đường đi
# param[in] none
#-----------------------------------------------------------
UNTRACK:
    li $at, TRACKING           # Thay đổi port TRACKING
    sb $zero, 0($at)           # thành 0 để ngừng vẽ đường đi
    nop
    jr $ra
    nop

#-----------------------------------------------------------
# ROTATE procedure, để Marsbot quay một góc nhất định
# param[in] $a0: góc quay (0-359)
#-----------------------------------------------------------
ROTATE:
    sw $a0, HEADING($zero)     # Thiết lập góc quay
    nop
    jr $ra
    nop

#-----------------------------------------------------------
# DRAW_TRACK procedure, để vẽ dấu vết
# param[in] none
#-----------------------------------------------------------
DRAW_TRACK:
    lb $v0, WHEREX             # Lấy vị trí x hiện tại của Marsbot
    lb $v1, WHEREY             # Lấy vị trí y hiện tại của Marsbot
    li $at, TRACKING        # Lưu ký tự vẽ dấu vết vào $at
    sb $at, 0($v1)        # Vẽ dấu vết tại vị trí hiện tại
    nop
    jr $ra
    nop

#-----------------------------------------------------------
# UPDATE_POSITION procedure, để cập nhật vị trí hiện tại của Marsbot
# param[in] $a0: di chuyển theo trục x (0: không di chuyển, 1: di chuyển sang phải, -1: di chuyển sang trái)
# param[in] $a1: di chuyển theo trục y (0: không di chuyển, 1: di chuyển lên, -1: di chuyển xuống)
#-----------------------------------------------------------
UPDATE_POSITION:
    lb $v0, WHEREX             # Lấy vị trí x hiện tại của Marsbot
    lb $v1, WHEREY             # Lấy vị trí y hiện tại của Marsbot
    add $v0, $v0, $a0          # Cập nhật vị trí x dựa trên di chuyển theo trục x
    add $v1, $v1, $a1          # Cập nhật vị trí y dựa trên di chuyển theo trục y
    sb $v0, WHEREX             # Lưu vị trí x mới
    sb $v1, WHEREY             # Lưu vị trí y mới
    nop
    jr $ra
    nop