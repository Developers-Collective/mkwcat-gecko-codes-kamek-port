.text
.align 4

.extern Player_ID # 0x80355160, mPlayerType__9daPyMng_c in the og
.extern WriteNumberToTextBox__FPiPCiPQ34nw4r3lyt7TextBoxb # 0x800B3B60, writeIntToTextBox in the og
.extern SetVolume__Q44nw4r3snd6detail10BasicSoundFfi # 0x80267560, nw4r_snd_detail_BasicSound_SetVolume in the og
.extern getPictures__Q23m2d13EmbedLayout_cCFPPCcPPQ34nw4r3lyt7Picturei # 0x800C8F30

.extern DWORD_8093CDF0 # 0x8093CDF0
.extern DWORD_8093F520 # 0x8093F520
.extern WMPlayer_loadSubplayers # 0x80902BD0

.extern returnFrom_WMPlayerUseSubplayerModel # 0x80902B80
.extern returnFrom_WMSubplayerFix01 # 0x80902D5C
.extern returnFrom_WMSubplayerFix02 # 0x80902D70
.extern returnFrom_WMSubplayerFixFloat # 0x80902E18
.extern returnFrom_WMSubplayerFixStatusOnLoad # 0x80909414
.extern returnFrom_FixWMSubplayerLoadModelArray1 # 0x808EB7DC
.extern returnFrom_FixWMSubplayerLoadModelArray2 # 0x808EB7E8
.extern returnFrom_PlayerDecideSound # 0x807A1C98
.extern returnFrom_IncreaseCourseInVolumeSaveParam2 # 0x8019AAB8
.extern returnFrom_IncreaseCourseInVolume # 0x8019AB90
.extern returnFrom_WMStarPowerupSound # 0x807B077C
.extern returnFrom_WMChangeP1Model_SaveReg # 0x80902ED8
.extern returnFrom_DontSetP1PowerupToMario # 0x80903020
.extern returnFrom_WMChangeP1Model # 0x80902F24
.extern returnFrom_ChangePSELBmgForPlayerCount # 0x807A10CC
.extern returnFrom_CancelAddDropCheckPlayer1 # 0x807A0D28
.extern returnFrom_CancelAddDropFix # 0x807A0D44
.extern returnFrom_CancelAfterRegisteredFix # 0x807A0D6C
.extern returnFrom_PreventJumpOnWM # 0x808C5E00
.extern returnFrom_CharacterChangeSelectBase_FixDefaultSelection # 0x8076FF10
.extern returnFrom_CharacterChangeSelectBase_FixDefaultSelection2 # 0x8076FE88
.extern returnFrom_CharacterChangeSelectBase_FixMarioVoice # 0x80771180
.extern returnFrom_CharacterChangeSelectBase_FixMarioVoiceMini # 0x80771168
.extern returnFrom_CharacterChangeSelectBase_FixInUseCheck # 0x8076FDC8
.extern returnFrom_CharacterChangeSelectBase_FixInUseCheck2 # 0x8076FDD8
.extern returnFrom_CharacterChangeSelectContents_GrabMarioIconPanes # 0x8076FDDC
.extern returnFrom_CharacterChangeSelectContents_MakeMarioIconPanesInvisible # 0x8077335C
.extern returnFrom_CharacterChangeSelectBase_FixIconUpdate # 0x807735A0
.extern returnFrom_CharacterChangeSelectBase_FixIconUpdate_2 # 0x80773658


# Copy subplayer model into player 1 model

.global WMPlayerUseSubplayerModel
WMPlayerUseSubplayerModel:
    mr      r3, r31
    bl      WMPlayer_loadSubplayers

    # Find the subplayer model
    lis     r9, Player_ID@ha
    lwz     r9, Player_ID@l(r9) # Player 1 character
    lwz     r10, 0x184(r31)

L_WMPlayerUseSubplayerModel_Loop:
    lwz     r4, 0x4(r10) # Character index
    rlwinm  r4, r4, 2, 0x3C
    addis   r4, r4, DWORD_8093CDF0@ha
    lwz     r4, DWORD_8093CDF0@l(r4)

    cmpw    r9, r4
    bne     L_WMPlayerUseSubplayerModel_LoopCond

	# Copy the model
    lwz     r4, 0x1CC(r10)
    lwz     r4, 0x4(r4)
    stw     r4, 0x1CC + 0x4(r31)
    b       L_WMPlayerUseSubplayerModel_Out

L_WMPlayerUseSubplayerModel_LoopCond:
    lwz     r10, 0x184(r10)
    cmpwi   r10, 0
    bne     L_WMPlayerUseSubplayerModel_Loop

L_WMPlayerUseSubplayerModel_Out:
	b       returnFrom_WMPlayerUseSubplayerModel


# Only call this thing with 1 on subplayers

.global WMSubplayerFix01
WMSubplayerFix01:
    subic   r5, r23, 1
    subfe   r5, r5, r23
	b       returnFrom_WMSubplayerFix01

.global WMSubplayerFix02
WMSubplayerFix02:
    subic   r5, r23, 1
    subfe   r5, r5, r23
	b       returnFrom_WMSubplayerFix02


# Fix some float thing in WM subplayer

.global WMSubplayerFixFloat
WMSubplayerFixFloat:
    stw     r3, 0x294(r4) # Original instruction
    lwz     r4, 0x184(r4)
    stw     r3, 0x294(r4)

    # Then copy player 1's status thing
    lwz     r9, 0x384(r31)
    lis     r10, Player_ID@ha
    lwz     r10, Player_ID@l(r10) # Player 1 character
    slwi    r10, r10, 2
    stwx    r9, r6, r10
	b 		returnFrom_WMSubplayerFixFloat


# Pre-copy the status as well when loading in from the menu

.global WMSubplayerFixStatusOnLoad
WMSubplayerFixStatusOnLoad:
    lwz     r0, 0x0(r6)
    slwi    r0, r0, 2

    lwz     r8, 0x384(r5)
    cmpwi   r8, 0x3
    beq     L_WMSubplayerFixStatusOnLoad_NotActive

    mr      r8, r4

L_WMSubplayerFixStatusOnLoad_NotActive:
    stwx    r8, r3, r0
    addi    r7, r5, 0x8 # Original instruction
    b       returnFrom_WMSubplayerFixStatusOnLoad


# Fix wrong array used in WM subplayer load model function
# (This is a base game bug I guess)

.global FixWMSubplayerLoadModelArray1
FixWMSubplayerLoadModelArray1:
	lis r5, DWORD_8093CDF0@ha
	b returnFrom_FixWMSubplayerLoadModelArray1

.global FixWMSubplayerLoadModelArray2
FixWMSubplayerLoadModelArray2:
	addi r5, r5, DWORD_8093CDF0@l
	b returnFrom_FixWMSubplayerLoadModelArray2


# Make a PLAYER_DECIDE sound for every other player as well

.global PlayerDecideSound
PlayerDecideSound:
    lis     r10, D_PlayerDecideSound_Sounds@h
    ori     r10, r10, D_PlayerDecideSound_Sounds@l

    lis     r9, Player_ID@ha
    lwz     r9, Player_ID@l(r9) # Player 1 character
    slwi    r9, r9, 1
    lhzx    r4, r10, r9

    # TODO: Can't think of a good way to do mini sounds for other characters
    bne     L_PlayerDecideSound_NotMini
    cmpwi   r9, 0
    bne     L_PlayerDecideSound_NotMini

    li      r4, 804 # SE_VOC_MA_PLAYER_DECIDE_MAME

L_PlayerDecideSound_NotMini:
	b 		returnFrom_PlayerDecideSound


# Save param 2 for following hook

.global IncreaseCourseInVolumeSaveParam2
IncreaseCourseInVolumeSaveParam2:
    mflr    r0
    stw     r4, 0x8(r1)
	b 		returnFrom_IncreaseCourseInVolumeSaveParam2

# Increase volume of course in to adjust for the multiplayer sound being quieter

.global IncreaseCourseInVolume
IncreaseCourseInVolume:
    # Effectively the original instruction
    stfs    f1, 0xBC(r3)

    # Check if Mario
    lwz     r0, 0xAC(r29)
    cmpwi   r0, 0
    beq     cr7, IncreaseCourseInVolume_Out

    # Check if COURSE_IN sound
    lwz     r0, 0x8(r1)
    cmpwi   r0, 5
    beq     IncreaseCourseInVolume_CorrectSound

    cmpwi   r0, 7
    bne     IncreaseCourseInVolume_Out

IncreaseCourseInVolume_CorrectSound:
	lis 	r4, D_IncreaseCourseInVolume_Volume@h
	ori     r4, r4, D_IncreaseCourseInVolume_Volume@l

    lfs     f1, 0(r4)
    li      r4, 0
    bl      SetVolume__Q44nw4r3snd6detail10BasicSoundFfi

IncreaseCourseInVolume_Out:
	b 		returnFrom_IncreaseCourseInVolume


# Fix the voice used when selecting a star on the powerup menu
.global WMStarPowerupSound
WMStarPowerupSound:
	lis 	r10, D_WMStarPowerupSound_Sounds@h
	ori 	r10, r10, D_WMStarPowerupSound_Sounds@l

    lwz     r9, 0x0(r6); // Character
    slwi    r9, r9, 1;
    lhzx    r4, r10, r9;

    # TODO: Mini sounds
	b 		returnFrom_WMStarPowerupSound

# Save WMPlayer class

.global WMChangeP1Model_SaveReg
WMChangeP1Model_SaveReg:
    mflr    r0
    stw     r3, 0x8(r1)
	b       returnFrom_WMChangeP1Model_SaveReg


# Fix FUN_80902fa0

.global DontSetP1PowerupToMario
DontSetP1PowerupToMario:
    b returnFrom_DontSetP1PowerupToMario


# Set the player 1 model after changing characters

.global WMChangeP1Model
WMChangeP1Model:
    lis     r9, Player_ID@ha
    lwz     r9, Player_ID@l(r9) # Player 1 character
    cmpw    r9, r28
    bne     WMChangeP1Model_Out

    lwz     r9, 0x8(r1)
    stw     r3, 0x1CC + 0x4(r9)  

WMChangeP1Model_Out:
    lwz     r12, 0x0(r3) # Original instruction
	b       returnFrom_WMChangeP1Model


# Change dNumberOfPeopleChange_c::executeState_InitialSetup
  
.global ChangePSELBmgForPlayerCount
ChangePSELBmgForPlayerCount:
	cmpwi 	r0, 1
	beq 	ChangePSELBmgForPlayerCount_1P

	li 		r6, 0x1C # Original instruction
	b 		ChangePSELBmgForPlayerCount_Out

ChangePSELBmgForPlayerCount_1P:
	li 		r6, 0x63

ChangePSELBmgForPlayerCount_Out:
	b 		returnFrom_ChangePSELBmgForPlayerCount


# Prevent cancelling Add/Drop players when player 1 is not registered

.global CancelAddDropCheckPlayer1
CancelAddDropCheckPlayer1:
    mflr    r0 # Original instruction
    # Check if player 1 is registered
    lwz     r4, 0x74(r3)
    lbz     r4, 0x29A(r4)
	b 		returnFrom_CancelAddDropCheckPlayer1


# For pressing 2 in an inappropiate time at the World Map

.global CancelAddDropFix
CancelAddDropFix:
    # Return 0 if player 1 is not registered
    cmpwi   r4, 0
    bne-    L_CancelAddDropFix_Out

    li      r3, 0

    # Return the function
    lwz     r0, 0x14(r1)
    mtlr    r0
    addi    r1, r1, 0x10
    blr

L_CancelAddDropFix_Out:
    li      r4, 0x900 # Original instruction
	b 		returnFrom_CancelAddDropFix


# For pressing 1 in an inappropiate time in the Main Menu

.global CancelAfterRegisteredFix
CancelAfterRegisteredFix:
    li      r3, 0 # Original instruction

    # Return 0 if player 1 is registered
    cmpwi   r4, 0
    beq-    L_CancelAfterRegisteredFix_Out

    # Return the function
    lwz     r0, 0x14(r1)
    mtlr    r0
    addi    r1, r1, 0x10
    blr

L_CancelAfterRegisteredFix_Out:
	b 		returnFrom_CancelAfterRegisteredFix


# Prevent 2D player 1 from jumping here

.global PreventJumpOnWM
PreventJumpOnWM:
    lis     r9, Player_ID@ha
    lwz     r9, Player_ID@l(r9)
    lwz     r10, 0x4(r3)
    rlwinm. r10, r10, 0, 0xF
    # r9 == r10
    xor     r10, r10, r9
    cntlzw  r10, r10
    srwi.   r10, r10, 5
	b 		returnFrom_PreventJumpOnWM


# Fix default selection for Mario

.global CharacterChangeSelectBase_FixDefaultSelection
CharacterChangeSelectBase_FixDefaultSelection:
    cmpwi   r0, 0
    bne     CharacterChangeSelectBase_FixDefaultSelection_Out

    li      r0, 4

CharacterChangeSelectBase_FixDefaultSelection_Out:
    li      r4, 0 # Original instruction
	b 		returnFrom_CharacterChangeSelectBase_FixDefaultSelection


.global CharacterChangeSelectBase_FixDefaultSelection2
CharacterChangeSelectBase_FixDefaultSelection2:
    cmpwi   r0, 0
    bne     CharacterChangeSelectBase_FixDefaultSelection2_Out

    li      r0, 4

CharacterChangeSelectBase_FixDefaultSelection2_Out:
    stw     r0, 0x2E0(r3) # Original instruction
	b 		returnFrom_CharacterChangeSelectBase_FixDefaultSelection2


# Fix Mario's voice on select

.global CharacterChangeSelectBase_FixMarioVoice
CharacterChangeSelectBase_FixMarioVoice:
    li      r4, 1010 # SE_VOC_KO2_PLAYER_JOIN

    lwz     r0, 0x2D4(r31)
    cmpwi   r0, 0
    bne     CharacterChangeSelectBase_FixMarioVoice_NotMario

    li      r4, 797 # SE_VOC_MA_PLAYER_JOIN

CharacterChangeSelectBase_FixMarioVoice_NotMario:
	b 		returnFrom_CharacterChangeSelectBase_FixMarioVoice


.global CharacterChangeSelectBase_FixMarioVoiceMini
CharacterChangeSelectBase_FixMarioVoiceMini:
    li      r4, 1011 # SE_VOC_KO2_PLAYER_JOIN_MAME

    lwz     r0, 0x2D4(r31)
    cmpwi   r0, 0
    bne     CharacterChangeSelectBase_FixMarioVoiceMini_NotMario

    li      r4, 798 # SE_VOC_MA_PLAYER_JOIN_MAME

CharacterChangeSelectBase_FixMarioVoiceMini_NotMario:
	b 		returnFrom_CharacterChangeSelectBase_FixMarioVoiceMini


# Change Mario icon

.global CharacterChangeSelectBase_FixInUseCheck
CharacterChangeSelectBase_FixInUseCheck:
    cmpwi   r31, 7
    bne     CharacterChangeSelectBase_FixInUseCheck_Out

    li      r4, 0

CharacterChangeSelectBase_FixInUseCheck_Out:
    mr      r3, r29
	b 		returnFrom_CharacterChangeSelectBase_FixInUseCheck


.global CharacterChangeSelectBase_FixInUseCheck2
CharacterChangeSelectBase_FixInUseCheck2:
    cmpwi   r31, 7
    bne     CharacterChangeSelectBase_FixInUseCheck2_Out

    li      r31, 8

CharacterChangeSelectBase_FixInUseCheck2_Out:
    cmpwi   r31, 0
	b 		returnFrom_CharacterChangeSelectBase_FixInUseCheck2


.global CharacterChangeSelectContents_GrabMarioIconPanes
CharacterChangeSelectContents_GrabMarioIconPanes:
	addi 	r3, r30, 0x70
	lis 	r4, MarioIconPicturePanes@h
	ori 	r4, r4, MarioIconPicturePanes@l
	addi 	r5, r30, 0x2B8
	li 		r6, 2
	bl 		getPictures__Q23m2d13EmbedLayout_cCFPPCcPPQ34nw4r3lyt7Picturei

	addi 	r3, r30, 0x70 # Original instruction
	b 		returnFrom_CharacterChangeSelectContents_GrabMarioIconPanes


.global CharacterChangeSelectContents_MakeMarioIconPanesInvisible
CharacterChangeSelectContents_MakeMarioIconPanesInvisible:
	# Original code

	lwz     r6, 0x254(r7)
	addi    r7, r7, 8
	lbz     r0, 0xBB(r6)
	rlwinm  r0, r0, 0, 24, 30
	stb     r0, 0xBB(r6)
	bdnz    CharacterChangeSelectContents_MakeMarioIconPanesInvisible

	# New code

    slwi    r0, r31, 2
    add     r6, r30, r0

 	lwz     r6, 0x2B8(r6)
    lbz     r0, 0xBB(r6)
    rlwinm  r0, r0, 0, 24, 30
    stb     r0, 0xBB(r6)

    b returnFrom_CharacterChangeSelectContents_MakeMarioIconPanesInvisible


# Read array differently

.global CharacterChangeSelectBase_FixIconUpdate
CharacterChangeSelectBase_FixIconUpdate:
    cmpwi   r4, 7
    beq     CharacterChangeSelectBase_FixIconUpdate_MarioUnlocked

    cmpwi   r4, 8
    bne     CharacterChangeSelectBase_FixIconUpdate_Else

CharacterChangeSelectBase_FixIconUpdate_MarioLocked:
    # Make the gray out thing visible
    slwi    r0, r5, 2
    add     r5, r3, r0
    lwz     r5, 0x254(r5)
    lbz     r0, 0xBB(r5)
    ori     r0, r0, 0x01
    stb     r0, 0xBB(r5)
    # Fall through

CharacterChangeSelectBase_FixIconUpdate_MarioUnlocked:
    addi    r3, r3, 0x2A4 # param 1
    slwi    r0, r31, 2
    lis     r4, DWORD_8093F520@ha
    addi    r4, r4, DWORD_8093F520@l # param 2
    add     r5, r30, r0 # param 3
    lwz     r5, 0x274(r5)
    li      r6, 0 # param 4

    # Call the function
    lis     r12, WriteNumberToTextBox__FPiPCiPQ34nw4r3lyt7TextBoxb@h
    ori     r12, r12, WriteNumberToTextBox__FPiPCiPQ34nw4r3lyt7TextBoxb@l
    mtctr   r12
    bctrl

    slwi    r0, r31, 2
    add     r5, r30, r0

    lwz     r5, 0x2B8(r5)
    lbz     r0, 0xBB(r5)
    rlwinm  r0, r0, 0, 24, 30
    ori     r0, r0, 0x01
    stb     r0, 0xBB(r5)

    b returnFrom_CharacterChangeSelectBase_FixIconUpdate_2

CharacterChangeSelectBase_FixIconUpdate_Else:
    cmpwi   r4, 4

CharacterChangeSelectBase_FixIconUpdate_Out:
	b 		returnFrom_CharacterChangeSelectBase_FixIconUpdate


.data
.align 4

D_PlayerDecideSound_Sounds:
	.short 803 # SE_VOC_MA_PLAYER_DECIDE,
    .short 882 # SE_VOC_LU_CS_DECIDE_JOIN,
    .short 953 # SE_VOC_KO_CS_DECIDE_JOIN,
    .short 1023 # SE_VOC_KO2_CS_DECIDE_JOIN

D_IncreaseCourseInVolume_Volume:
	.float 2.0

D_WMStarPowerupSound_Sounds:
    .short 854 # SE_VOC_MA_GET_STAR
    .short 925 # SE_VOC_LU_GET_STAR
    .short 996 # SE_VOC_KO_GET_STAR
    .short 1066 # SE_VOC_KO2_GET_STAR

aP_mar_00:
	.string "P_mar_00"
	.align 4

aP_mar_01:
	.string "P_mar_01"
	.align 4

MarioIconPicturePanes:
	.long aP_mar_00
	.long aP_mar_01