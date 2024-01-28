; Macros
 %macro xrectv 6
  dd %1, %2, %3
  dd %1, %2, %6
  dd %4, %2, %6
  dd %4, %2, %3
  %endmacro
 %macro yrectv 6
  dd %1, %2, %3
  dd %1, %5, %3
  dd %4, %5, %6
  dd %4, %2, %6
  %endmacro
 %macro yrectl 6
  dd %1, %2, %3, %4, %2, %6
  dd %4, %2, %6, %4, %5, %6
  dd %4, %5, %6, %1, %5, %3
  dd %1, %5, %3, %1, %2, %3
  %endmacro
 %macro recte 1
  dw %1, %1+1, %1+2, %1+3
  %endmacro
 %macro rprismv 6
  dd %1, %2, %3
  dd %1, %5, %3
  dd %4, %5, %3
  dd %4, %2, %3
  dd %1, %2, %6
  dd %1, %5, %6
  dd %4, %5, %6
  dd %4, %2, %6
  %endmacro
 %macro rprisme 1
  dw %1+0, %1+1, %1+1, %1+2, %1+2, %1+3, %1+3, %1+0
  dw %1+4, %1+5, %1+5, %1+6, %1+6, %1+7, %1+7, %1+4
  dw %1+0, %1+4, %1+1, %1+5, %1+2, %1+6, %1+3, %1+7
  %endmacro
 %macro rprisml 6
  dd %1, %2, %3, %4, %2, %3
  dd %4, %2, %3, %4, %5, %3
  dd %4, %5, %3, %1, %5, %3
  dd %1, %5, %3, %1, %2, %3
  dd %1, %2, %6, %4, %2, %6
  dd %4, %2, %6, %4, %5, %6
  dd %4, %5, %6, %1, %5, %6
  dd %1, %5, %6, %1, %2, %6
  dd %1, %2, %3, %1, %2, %6
  dd %4, %2, %3, %4, %2, %6
  dd %4, %5, %3, %4, %5, %6
  dd %1, %5, %3, %1, %5, %6
  %endmacro
 %macro ywinv 7
  dd %1, %2, %3, %7
  dd %1, %5, %3, %7
  dd %4, %5, %6, %7
  dd %4, %2, %6, %7
  %endmacro
 %macro ywine 1
  dw %1+0, %1+1, %1+2
  dw %1+2, %1+3, %1+0
  %endmacro
 %macro counte 2
  %assign o %1
  %rep %2-%1
   dw o
   %assign o o+1
   %endrep
  %endmacro
; Notes
 ; The calling convention is System V AMD64 ABI. The order is RDI, RSI, RDX, RCX, R8, R9, MM0-7. Floating points are passed via xmm0-7
 ; Exit codes
  ; 00 - Normal exit
  ; 01 - glfwInit failure
  ; 02 - glfwCreateWindow failure
  ; 03 - Shader initialization issue

; Linker stuff
 global main

 extern printf
 extern exit
 extern glfwInit
 extern glfwTerminate
 extern glfwWindowHint
 extern glfwCreateWindow
 extern glfwMakeContextCurrent
 extern glfwWindowShouldClose
 extern glfwSetKeyCallback
 extern glfwSetWindowSizeCallback
 extern glfwGetKey
 extern glfwSwapBuffers
 extern glfwPollEvents
 extern glGetError
 extern glGenVertexArrays
 extern glGenBuffers
 extern glBindVertexArray
 extern glBindBuffer
 extern glBindBufferBase
 extern glBufferData
 extern glBufferSubData
 extern glGetNamedBufferSubData
 extern glEnableVertexAttribArray
 extern glVertexAttribPointer
 extern glVertexAttribIPointer
 extern glCreateShader
 extern glShaderSource
 extern glCompileShader
 extern glGetShaderiv
 extern glGetShaderInfoLog
 extern glCreateProgram
 extern glAttachShader
 extern glLinkProgram
 extern glGetProgramiv
 extern glGetProgramInfoLog
 extern glUseProgram
 extern glDetachShader
 extern glDeleteShader
 extern glGetUniformLocation
 extern glUniform1i
 extern glUniform1ui
 extern glUniform1f
 extern glUniform2f
 extern glUniform2fv
 extern glUniform3f
 extern glUniform3fv
 extern glViewport
 extern glPointSize
 extern glClearColor
 extern glClear
 extern glEnable
 extern glDrawElements
 extern glMultiDrawElements
 extern glDrawArrays

; Todo 
; Cleanup unnecessary r-prefixes
; Check if draw settings are ideal
main:
 sub rsp, 8 ; Allocate 8 extra bytes for alignment
 preprocess:
  ; Add offsets
   mov eax, r_1
   mov ecx, [roomcount]

   addoffsetloop:
   push rcx
   ; Triangles
    mov ebx, [eax+16] ; Vertice start
    mov ecx, [eax+20] ; Vertice count
    cmp ecx, 0
    je aol.lines
    aol.tr:
     movss xmm0, [eax+84]
     movss xmm1, [eax+88]
     movss xmm2, [eax+92]
     addss xmm0, [ebx+0]
     addss xmm1, [ebx+4]
     addss xmm2, [ebx+8]
     movss [ebx+0], xmm0
     movss [ebx+4], xmm1
     movss [ebx+8], xmm2
     add ebx, 16
     dec ecx
     cmp ecx, 0
     jne aol.tr
   ; Lines
    aol.lines:
    mov ebx, [eax+36] ; Vertice start
    mov ecx, [eax+40] ; Vertice count
    cmp ecx, 0
    je aol.lineloops
    aol.ln:
     movss xmm0, [eax+84]
     movss xmm1, [eax+88]
     movss xmm2, [eax+92]
     addss xmm0, [ebx+0]
     addss xmm1, [ebx+4]
     addss xmm2, [ebx+8]
     movss [ebx+0], xmm0
     movss [ebx+4], xmm1
     movss [ebx+8], xmm2
     add ebx, 12
     dec ecx
     cmp ecx, 0
     jne aol.ln
   ; Lineloops
    aol.lineloops:
    mov ebx, [eax+56] ; Vertice start
    mov ecx, [eax+60] ; Vertice count
    cmp ecx, 0
    je aol.linestrips
    aol.ll:
     movss xmm0, [eax+84]
     movss xmm1, [eax+88]
     movss xmm2, [eax+92]
     addss xmm0, [ebx+0]
     addss xmm1, [ebx+4]
     addss xmm2, [ebx+8]
     movss [ebx+0], xmm0
     movss [ebx+4], xmm1
     movss [ebx+8], xmm2
     add ebx, 12
     dec ecx
     cmp ecx, 0
     jne aol.ll
   ; Linestrips
    aol.linestrips:
    mov ebx, [eax+76] ; Vertice start
    mov ecx, [eax+80] ; Vertice count
    cmp ecx, 0
    je aol.next
    aol.ls:
     movss xmm0, [eax+84]
     movss xmm1, [eax+88]
     movss xmm2, [eax+92]
     addss xmm0, [ebx+0]
     addss xmm1, [ebx+4]
     addss xmm2, [ebx+8]
     movss [ebx+0], xmm0
     movss [ebx+4], xmm1
     movss [ebx+8], xmm2
     add ebx, 12
     dec ecx
     cmp ecx, 0
     jne aol.ls
   aol.next:
   add eax, 96
   pop rcx
   dec ecx
   cmp ecx, 0
   jne addoffsetloop
 windowinit:
  ; glfwInit
   mov bx, '01'
   call glfwInit
   test al, 1
   jz close.noterminate
  ; Window hints
   mov edi, 0x22002 ; GLFW_CONTEXT_VERSION_MAJOR
   mov esi, 4
   call glfwWindowHint

   mov edi, 0x22003 ; GLFW_CONTEXT_VERSION_MINOR
   mov esi, 5
   call glfwWindowHint

   mov edi, 0x22006 ; GLFW_OPENGL_FORWARD_COMPAT
   mov esi, 1
   call glfwWindowHint

   mov edi, 0x22008 ; GLFW_OPENGL_PROFILE
   mov esi, 0x32001 ; GLFW_OPENGL_CORE_PROFILE
   call glfwWindowHint

   mov edi, 0x2100D ; GLFW_SAMPLES
   mov esi, 4
   call glfwWindowHint
  ; glfwCreateWindow
   mov edi, 1600
   mov esi, 900
   mov rdx, str.winname
   mov ecx, 0
   mov r8, 0
   call glfwCreateWindow
 
   mov bx, '02'
   cmp rax, 0
   je close

   mov [window], rax
  ; glfwMakeContextCurrent
   mov rdi, [window]
   call glfwMakeContextCurrent
  ; glfwSetCallbacks
   mov rdi, [window]
   mov esi, keypress
   call glfwSetKeyCallback
   
   mov rdi, [window]
   mov esi, resize
   call glfwSetWindowSizeCallback
 bufferinit:
  ; Gen buffers
   mov edi, 5
   mov esi, vao.ln
   call glGenVertexArrays
   mov edi, 11
   mov esi, vbo.ln
   call glGenBuffers
  ; Buffer point data
   mov edi, [vao.pt]
   call glBindVertexArray

   mov edi, 0x8892 ; GL_ARRAY_BUFFER
   mov esi, [vbo.pt]
   call glBindBuffer

   mov edi, 0x8892
   mov esi, 12
   mov edx, points
   mov ecx, 0x88E4 ; GL_STATIC_DRAW
   call glBufferData

   mov edi, 0      ; Location
   mov esi, 3      ; Vertex attributes
   mov edx, 0x1406 ; GL_FLOAT
   mov ecx, 0      ; GL_FALSE
   mov r8d, 12     ; Stride
   mov r9d, 0      ; Skip
   call glVertexAttribPointer

   xor edi, edi
   call glEnableVertexAttribArray
  ; Buffer line data
   mov edi, [vao.ln]
   call glBindVertexArray
   
   mov edi, 0x8892 ; GL_ARRAY_BUFFER
   mov esi, [vbo.ln]
   call glBindBuffer

   mov edi, 0x8892
   mov esi, lines.end-lines
   mov edx, lines
   mov ecx, 0x88E8 ; GL_DYNAMIC_DRAW
   call glBufferData

   mov edi, 0x8893 ; GL_ELEMENT_ARRAY_BUFFER
   mov esi, [ebo.ln]
   call glBindBuffer

   mov edi, 0x8893
   mov esi, lines.elements.end-lines.elements
   mov edx, lines.elements
   mov ecx, 0x88E4 ; GL_STATIC_DRAW
   call glBufferData

   mov edi, 0      ; Location
   mov esi, 3      ; Vertex attributes
   mov edx, 0x1406 ; GL_FLOAT
   mov ecx, 0      ; GL_FALSE
   mov r8d, 12     ; Stride
   mov r9d, 0      ; Skip
   call glVertexAttribPointer

   xor edi, edi
   call glEnableVertexAttribArray
  ; Buffer line loop data
   mov edi, [vao.ll]
   call glBindVertexArray
   
   mov edi, 0x8892 ; GL_ARRAY_BUFFER
   mov esi, [vbo.ll]
   call glBindBuffer

   mov edi, 0x8892
   mov esi, lineloops.end-lineloops
   mov edx, lineloops
   mov ecx, 0x88E8 ; GL_DYNAMIC_DRAW
   call glBufferData

   mov edi, 0x8893 ; GL_ELEMENT_ARRAY_BUFFER
   mov esi, [ebo.ll]
   call glBindBuffer

   mov edi, 0x8893
   mov esi, lineloops.elements.end-lineloops.elements
   mov edx, lineloops.elements
   mov ecx, 0x88E4 ; GL_STATIC_DRAW
   call glBufferData

   mov edi, 0      ; Start
   mov esi, 3      ; Vertex attributes
   mov edx, 0x1406 ; GL_FLOAT
   mov ecx, 0      ; GL_FALSE
   mov r8d, 12     ; Stride
   mov r9d, 0      ; Skip
   call glVertexAttribPointer

   xor edi, edi
   call glEnableVertexAttribArray
  ; Buffer line strip data
   mov edi, [vao.ls]
   call glBindVertexArray
   
   mov edi, 0x8892 ; GL_ARRAY_BUFFER
   mov esi, [vbo.ls]
   call glBindBuffer

   mov edi, 0x8892
   mov esi, linestrips.end-linestrips
   mov edx, linestrips
   mov ecx, 0x88E8 ; GL_DYNAMIC_DRAW
   call glBufferData

   mov edi, 0x8893 ; GL_ELEMENT_ARRAY_BUFFER
   mov esi, [ebo.ls]
   call glBindBuffer

   mov edi, 0x8893
   mov esi, linestrips.elements.end-linestrips.elements
   mov edx, linestrips.elements
   mov ecx, 0x88E4 ; GL_STATIC_DRAW
   call glBufferData

   mov edi, 0      ; Start
   mov esi, 3      ; Vertex attributes
   mov edx, 0x1406 ; GL_FLOAT
   mov ecx, 0      ; GL_FALSE
   mov r8d, 12     ; Stride
   mov r9d, 0      ; Skip
   call glVertexAttribPointer

   xor edi, edi
   call glEnableVertexAttribArray
  ; Buffer triangle data
   mov edi, [vao.tr]
   call glBindVertexArray
   
   mov edi, 0x8892 ; GL_ARRAY_BUFFER
   mov esi, [vbo.tr]
   call glBindBuffer

   mov edi, 0x8892
   mov esi, triangles.end-triangles
   mov edx, triangles
   mov ecx, 0x88E8 ; GL_DYNAMIC_DRAW
   call glBufferData

   mov edi, 0x8893 ; GL_ELEMENT_ARRAY_BUFFER
   mov esi, [ebo.tr]
   call glBindBuffer

   mov edi, 0x8893
   mov esi, triangles.elements.end-triangles.elements
   mov edx, triangles.elements
   mov ecx, 0x88E4 ; GL_STATIC_DRAW
   call glBufferData

   mov edi, 0      ; Start
   mov esi, 3      ; Vertex attributes
   mov edx, 0x1406 ; GL_FLOAT
   mov ecx, 0      ; GL_FALSE
   mov r8d, 16     ; Stride
   mov r9d, 0      ; Skip
   call glVertexAttribPointer

   mov edi, 1      ; Location
   mov esi, 1      ; Vertex attributes
   mov edx, 0x1405 ; GL_UNSIGNED_INT
   mov ecx, 16     ; Stride
   mov r8d, 12     ; Skip
   call glVertexAttribIPointer

   xor edi, edi
   call glEnableVertexAttribArray
   mov edi, 1
   call glEnableVertexAttribArray
  ; Buffer SSBOs
   mov edi, 0x90D2 ; GL_SHADER_STORAGE_BUFFER
   mov esi, [sbo.wc]
   call glBindBuffer

   mov edi, 0x90D2
   mov esi, 2000 * 2000 * 4 + 4
   mov edx, 0
   mov ecx, 0x88E8 ; GL_DYNAMIC_DRAW
   call glBufferData

   mov edi, 0x90D2
   mov esi, 0
   mov edx, 4
   mov ecx, w
   call glBufferSubData

   mov edi, 0x90D2
   mov esi, 5
   mov edx, [sbo.wc]
   call glBindBufferBase

   mov edi, 0x90D2 ; GL_SHADER_STORAGE_BUFFER
   mov esi, [sbo.dp]
   call glBindBuffer

   mov edi, 0x90D2
   mov esi, 2000 * 2000 * 4 + 4
   mov edx, 0
   mov ecx, 0x88E8 ; GL_DYNAMIC_DRAW
   call glBufferData

   mov edi, 0x90D2
   mov esi, 6
   mov edx, [sbo.dp]
   call glBindBufferBase

   mov edi, 0x90D2
   mov esi, 0
   call glBindBuffer
 shaderinit:
  mov bx, '03'
  ; Create vertex shader
   mov edi, 0x8B31 ; GL_VERTEX_SHADER
   call glCreateShader
   mov [scratch0], eax 

   mov edi, [scratch0]
   mov esi, 1
   mov rdx, str.vertshader.pointer
   mov ecx, 0
   call glShaderSource

   mov edi, [scratch0]
   call glCompileShader

   mov edi, [scratch0]
   mov esi, 0x8B81 ; GL_COMPILE_STATUS
   mov edx, scratch2
   call glGetShaderiv

   test dword [scratch2], 1
   jnz fragshader
   ; Vertshader debug
    mov edi, [scratch0]
    mov esi, 0xFE
    mov edx, 0
    mov ecx, str.scratch 
    call glGetShaderInfoLog
    mov rdi, str.scratch
    call printf
    jmp close
  ; Create fragment shader
   fragshader:
   mov edi, 0x8B30 ; GL_VERTEX_SHADER
   call glCreateShader
   mov [scratch1], eax

   mov edi, [scratch1]
   mov esi, 1
   mov rdx, str.fragshader.pointer
   mov ecx, 0
   call glShaderSource

   mov edi, [scratch1]
   call glCompileShader

   mov edi, [scratch1]
   mov esi, 0x8B81 ; GL_COMPILE_STATUS
   mov edx, scratch2
   call glGetShaderiv

   test dword [scratch2], 1
   jnz createprogram
   ; Vertshader debug
    mov edi, [scratch1]
    mov esi, 0xFE
    mov edx, 0
    mov ecx, str.scratch 
    call glGetShaderInfoLog
    mov edi, str.scratch
    call printf
    jmp close
  ; Create program
   createprogram:
   call glCreateProgram
   mov [shader], eax

   mov edi, [shader]
   mov esi, [scratch0]
   call glAttachShader

   mov edi, [shader]
   mov esi, [scratch1]
   call glAttachShader

   mov edi, [shader]
   call glLinkProgram

   mov edi, [shader]
   mov esi, 0x8B82 ; GL_LINK_STATUS
   mov edx, scratch2
   call glGetProgramiv
   test dword [scratch2], 1
   jnz useprogram
   ; Program debug
    mov edi, [shader]
    mov esi, 0xFE
    mov edx, 0
    mov rcx, str.scratch
    call glGetProgramInfoLog
    mov edi, str.scratch
    call printf
    jmp close

   useprogram:
   mov edi, [shader]
   call glUseProgram

   mov edi, [shader]
   mov esi, [scratch0]
   call glDetachShader

   mov edi, [shader]
   mov esi, [scratch1]
   call glDetachShader

   mov edi, [scratch0]
   call glDeleteShader

   mov edi, [scratch1]
   call glDeleteShader
  ; Setup uniforms
   mov edi, [shader]
   mov esi, screenres.name
   call glGetUniformLocation
   mov [screenres.handle], eax

   mov edi, [shader]
   mov esi, campos.name
   call glGetUniformLocation
   mov [campos.handle], eax

   mov edi, [shader]
   mov esi, camangle.name
   call glGetUniformLocation
   mov [camangle.handle], eax

   mov edi, [shader]
   mov esi, winclear.name
   call glGetUniformLocation
   mov [winclear.handle], eax

   mov edi, [shader]
   mov esi, iswindow.name
   call glGetUniformLocation
   mov [iswindow.handle], eax

   mov edi, [shader]
   mov esi, doorcheck.name
   call glGetUniformLocation
   mov [doorcheck.handle], eax

   mov edi, [shader]
   mov esi, vertw.name
   call glGetUniformLocation
   mov [vertw.handle], eax
 valuesinit:
  mov edi, [screenres.handle]
  mov esi, 1
  mov edx, screenres
  call glUniform2fv

  mov edi, [campos.handle]
  mov esi, 1
  mov edx, campos
  call glUniform3fv

  mov edi, [camangle.handle]
  mov esi, 1
  mov edx, camangle
  call glUniform3fv

  mov edi, 0x809D ; Enable multisampling
  call glEnable
 renderloop:
  mov edi, 0x4000 ; Color buffer bit
  call glClear
  
  ; Keypresses
   ; Relevants keys
    ; 065 - A
    ; 087 - W
    ; 083 - S
    ; 068 - D
    ; 032 - Space
    ; 340 - Left_Shift
    ; 263 - Left
    ; 265 - Up
    ; 264 - Down
    ; 262 - Right
    ; 081 - Q
    ; 069 - E
    ; 070 - F
   ; A
    mov rdi, [window]
    mov esi, 65
    call glfwGetKey
    test al, 1
    jnz keypress_a
    aret:
   ; D
    mov rdi, [window]
    mov esi, 68
    call glfwGetKey
    test al, 1
    jnz keypress_d
    dret:
   ; Space
    mov rdi, [window]
    mov esi, 32
    call glfwGetKey
    test al, 1
    jnz keypress_space
    spaceret:
   ; Shift
    mov rdi, [window]
    mov esi, 340
    call glfwGetKey
    test al, 1
    jnz keypress_shift
    shiftret:
   ; W
    mov rdi, [window]
    mov esi, 87
    call glfwGetKey
    test al, 1
    jnz keypress_w
    wret:
   ; S
    mov rdi, [window]
    mov esi, 83
    call glfwGetKey
    test al, 1
    jnz keypress_s
    sret:
   ; Left
    mov rdi, [window]
    mov esi, 263
    call glfwGetKey
    test al, 1
    jnz keypress_left
    leftret:
   ; Right
    mov rdi, [window]
    mov esi, 262
    call glfwGetKey
    test al, 1
    jnz keypress_right
    rightret:
   ; Up
    mov rdi, [window]
    mov esi, 265
    call glfwGetKey
    test al, 1
    jnz keypress_up
    upret:
   ; Down
    mov rdi, [window]
    mov esi, 264
    call glfwGetKey
    test al, 1
    jnz keypress_down
    downret:
   ; Q
    mov rdi, [window]
    mov esi, 81
    call glfwGetKey
    test al, 1
    jnz keypress_q
    qret:
   ; E
    mov rdi, [window]
    mov esi, 69
    call glfwGetKey
    test al, 1
    jnz keypress_e
    eret:
   ; F
    mov rdi, [window]
    mov esi, 70
    call glfwGetKey
    test al, 1
    jnz keypress_f
    fret:
  
  ; Get w
   mov edi, [sbo.wc] ; SSBO
   mov esi, 0        ; Offset
   mov edx, 4        ; Size
   mov ecx, w        ; Output 
   call glGetNamedBufferSubData

  ; Room renderloop
   mov eax, [w]
   mov ebx, 16
   mul ebx
   add eax, pointerlist
   mov ebx, [eax]   ; Pointer to renderlist entry
   mov ecx, [eax+4] ; Count
   cmp ecx, 0
   je renderskip

   renderloop.rooms:
    push rcx

    mov edi, [vertw.handle]
    mov eax, [ebx] 
    mov esi, [eax]
    call glUniform1ui
    ; Render
     ; Windows
      mov edi, [iswindow.handle]
      mov esi, 1
      call glUniform1i      
      mov edi, [vao.tr]
      call glBindVertexArray
      mov eax, [ebx]
      mov edi, 0x0004  ; GL_TRIANGLES
      mov esi, [eax+4]   ; Counts index 
      mov edx, 0x1403  ; GL_UNSIGNED_SHORT
      mov ecx, [eax+8] ; Indices index
      mov r8d, [eax+12] ; Rendercount
      call glMultiDrawElements
      mov edi, [iswindow.handle]
      mov esi, 0
      call glUniform1i
     ; Lines
      mov edi, [vao.ln]
      call glBindVertexArray
      mov eax, [ebx]
      mov edi, 0x0001   ; GL_LINES
      mov esi, [eax+24] ; Counts index 
      mov edx, 0x1403   ; GL_UNSIGNED_SHORT
      mov ecx, [eax+28] ; Indices index
      mov r8d, [eax+32] ; Rendercount
      call glMultiDrawElements
     ; Lineloops
      mov edi, [vao.ll]
      call glBindVertexArray
      mov eax, [ebx]
      mov edi, 0x0002   ; GL_LINE_LOOP
      mov esi, [eax+44] ; Counts index 
      mov edx, 0x1403   ; GL_UNSIGNED_SHORT
      mov ecx, [eax+48] ; Indices index
      mov r8d, [eax+52] ; Rendercount
      call glMultiDrawElements
     ; Linestrips
      mov edi, [vao.ls]
      call glBindVertexArray
      mov eax, [ebx]
      mov edi, 0x0003   ; GL_LINE_STRIP
      mov esi, [eax+64] ; Counts index 
      mov edx, 0x1403   ; GL_UNSIGNED_SHORT
      mov ecx, [eax+68] ; Indices index
      mov r8d, [eax+72] ; Rendercount
      call glMultiDrawElements
    pop rcx
    ; Loop
     add ebx, 4
     dec ecx
     cmp ecx, 0
     jne renderloop.rooms

  ; Points
   mov edi, [doorcheck.handle]
   mov esi, 1
   call glUniform1i
   mov edi, [vao.pt]
   call glBindVertexArray
   mov edi, 0x0000 ; GL_POINTS
   mov esi, 0  
   mov edx, 1
   call glDrawArrays
   mov edi, [doorcheck.handle]
   mov esi, 0
   call glUniform1i

  renderskip:
  ; Clear window buffer
   mov edi, [winclear.handle]
   mov esi, 1
   call glUniform1i
   mov edi, [vao.tr]
   call glBindVertexArray
   mov edi, 0x0004 ; GL_TRIANGLES
   mov esi, triangles.counts
   mov edx, 0x1403 ; GL_UNSIGNED_SHORT
   mov ecx, triangles.indices
   mov r8d, 1
   call glMultiDrawElements
   mov edi, [winclear.handle]
   mov esi, 0
   call glUniform1i

  ; Window calls
   mov rdi, [window]
   call glfwSwapBuffers 
   mov rdi, [window]
   call glfwPollEvents
   mov rdi, [window]
   call glfwWindowShouldClose
   test al, 1
   jz renderloop
 close:
  call glfwTerminate
  close.noterminate:

  mov [str.exitcode], bx
  mov rdi, str.exit
  call printf

  xor edi, edi
  mov di, bx
  call exit 
 
 ; glfw window events
  keypress:
   push rbx

   mov bx, '00'
   cmp esi, 256
   je close

   pop rbx
   ret
  resize:
   sub rsp, 8

   mov [screenres], esi
   mov [screenres+4], edx

   mov edi, 0
   mov esi, 0
   mov edx, [screenres]
   mov ecx, [screenres+4]
   call glViewport

   cvtsi2ss xmm0, [screenres]
   movss [screenres], xmm0
   cvtsi2ss xmm0, [screenres+4]
   movss [screenres+4], xmm0

   mov edi, [screenres.handle]
   mov esi, 1
   mov edx, screenres
   call glUniform2fv
   add rsp, 8
   ret

 ; Keypress functions
  keypress_a:
   fld dword [camangle+4]
   fsincos
   fstp dword [scratch0]
   fstp dword [scratch1]

   movss xmm0, [n10th]
   mulss xmm0, [scratch0]
   addss xmm0, [campos]
   movss [campos], xmm0

   movss xmm1, [n10th]
   mulss xmm1, [scratch1]
   addss xmm1, [campos+8]
   movss [campos+8], xmm1

   mov edi, [campos.handle]
   mov esi, 1
   mov edx, campos
   call glUniform3fv
   jmp aret
  keypress_d:
   fld dword [camangle+4]
   fsincos
   fstp dword [scratch0]
   fstp dword [scratch1]

   movss xmm0, [p10th]
   mulss xmm0, [scratch0]
   addss xmm0, [campos]
   movss [campos], xmm0

   movss xmm1, [p10th]
   mulss xmm1, [scratch1]
   addss xmm1, [campos+8]
   movss [campos+8], xmm1

   mov edi, [campos.handle]
   mov esi, 1
   mov edx, campos
   call glUniform3fv
   jmp dret
  keypress_space:
   movss xmm0, [campos+4]
   addss xmm0, [p10th]
   movss [campos+4], xmm0

   mov edi, [campos.handle]
   mov esi, 1
   mov edx, campos
   call glUniform3fv
   jmp spaceret
  keypress_shift:
   movss xmm0, [campos+4]
   addss xmm0, [n10th]
   movss [campos+4], xmm0

   mov edi, [campos.handle]
   mov esi, 1
   mov edx, campos
   call glUniform3fv
   jmp shiftret
  keypress_w:
   fld dword [camangle+4]
   fsincos
   fstp dword [scratch0]
   fstp dword [scratch1]

   movss xmm0, [n10th]
   mulss xmm0, [scratch1]
   addss xmm0, [campos]
   movss [campos], xmm0

   movss xmm1, [p10th]
   mulss xmm1, [scratch0]
   addss xmm1, [campos+8]
   movss [campos+8], xmm1

   mov edi, [campos.handle]
   mov esi, 1
   mov edx, campos
   call glUniform3fv
   jmp wret
  keypress_s:
   fld dword [camangle+4]
   fsincos
   fstp dword [scratch0]
   fstp dword [scratch1]

   movss xmm0, [p10th]
   mulss xmm0, [scratch1]
   addss xmm0, [campos]
   movss [campos], xmm0

   movss xmm1, [n10th]
   mulss xmm1, [scratch0]
   addss xmm1, [campos+8]
   movss [campos+8], xmm1

   mov edi, [campos.handle]
   mov esi, 1
   mov edx, campos
   call glUniform3fv
   jmp sret
  keypress_left:
   movss xmm0, [camangle+4]
   addss xmm0, [p50th]
   movss [camangle+4], xmm0

   mov edi, [camangle.handle]
   mov esi, 1
   mov edx, camangle
   call glUniform3fv
   jmp leftret
  keypress_right:
   movss xmm0, [camangle+4]
   addss xmm0, [n50th]
   movss [camangle+4], xmm0

   mov edi, [camangle.handle]
   mov esi, 1
   mov edx, camangle
   call glUniform3fv
   jmp rightret
  keypress_up: 
   movss xmm0, [p50th]
   addss xmm0, [camangle]
   movss [camangle], xmm0

   mov edi, [camangle.handle]
   mov esi, 1
   mov edx, camangle
   call glUniform3fv
   jmp upret
  keypress_down:  
   movss xmm0, [n50th]
   addss xmm0, [camangle]
   movss [camangle], xmm0

   mov edi, [camangle.handle]
   mov esi, 1
   mov edx, camangle
   call glUniform3fv
   jmp downret
  keypress_q:
   movss xmm0, [camangle+8]
   addss xmm0, [p50th]
   movss [camangle+8], xmm0

   mov edi, [camangle.handle]
   mov esi, 1
   mov edx, camangle
   call glUniform3fv
   jmp qret
  keypress_e:
   movss xmm0, [camangle+8]
   addss xmm0, [n50th]
   movss [camangle+8], xmm0

   mov edi, [camangle.handle]
   mov esi, 1
   mov edx, camangle
   call glUniform3fv
   jmp eret
  keypress_f:
   movss xmm0, [zero]
   movss [camangle+0], xmm0
   movss [camangle+4], xmm0
   movss [camangle+8], xmm0

   mov edi, [camangle.handle]
   mov esi, 1
   mov edx, camangle
   call glUniform3fv
   jmp fret

section .data
 ; Misc
  w dd 1
  scratch0 dd 0
  scratch1 dd 0
  scratch2 dd 0
  oldpos dd 0.0, 0.0, 0.0
  str.scratch times 0xFE db 'a'
  db 10, 0
  str.vertshader.pointer dq str.vertshader
  str.fragshader.pointer dq str.fragshader

 ; Strings
  ; Misc
   str.exit db 'Exited with code '
   str.exitcode db '00', 10, 0
   str.winname db 'Renderer', 0
   str.resize db 'Resized', 10, 0
   str.intprint db '%lu', 10, 0
   str.hexprint db '%#lx', 10, 0
   str.floatprint db '%f', 10, 0
  str.vertshader:
   db '#version 450', 10
   db 'layout (location = 0) in vec3 position;'
   db 'layout (location = 1) in uint vertwinw;'
   db 'out uint fragwinw;'
   db 'uniform uint vertw;'
   db 'uniform vec2 screenres;'
   db 'uniform vec3 campos;'
   db 'uniform vec3 camangle;'
   db 'uniform bool winclear;'
   db 'uniform bool doorcheck;'
   db 'void main()'
   db '{'
   db 'gl_Position = vec4(position, 1.0);'
   db 'fragwinw = vertwinw;'
   db 'if (winclear) { gl_Position.z = 0; return; }'
   db 'if (doorcheck) { return; }'
   db 'gl_Position.xyz -= campos;'
   db 'float oldposition_z = gl_Position.z;'
   db 'gl_Position.z = gl_Position.z * cos(camangle.y) - gl_Position.x * sin(camangle.y);'
   db 'gl_Position.x = oldposition_z * sin(camangle.y) + gl_Position.x * cos(camangle.y);'
   db 'float oldposition_y = gl_Position.y;'
   db 'gl_Position.y = gl_Position.y * cos(camangle.x) - gl_Position.z * sin(camangle.x);'
   db 'gl_Position.z = oldposition_y * sin(camangle.x) + gl_Position.z * cos(camangle.x);'
   db 'float oldposition_x = gl_Position.x;'
   db 'gl_Position.x = gl_Position.x * cos(camangle.z) - gl_Position.y * sin(camangle.z);'
   db 'gl_Position.y = oldposition_x * sin(camangle.z) + gl_Position.y * cos(camangle.z);'
   db 'gl_Position.x *= (screenres[1] / screenres[0]);'
   db 'gl_Position.w = gl_Position.z * 0.8;'
   db 'gl_Position.z = 0;'
   db '}', 0
  str.fragshader:
   ; Todo - CLEANUP
   ; Todo - Window functionality within adjacent dimensions
   db '#version 450', 10
   db 'out vec4 fragColor;'
   db 'in vec4 gl_FragCoord;'
   db 'flat in uint fragwinw;'
   db 'uniform uint vertw;'
   db 'uniform vec2 screenres;'
   db 'uniform float oldz;'
   db 'uniform bool winclear;'
   db 'uniform bool iswindow;'
   db 'uniform bool doorcheck;'
   db 'layout(binding = 5) buffer wincoordsbuffer { uint w; uint wincoords[4000000]; };'
   db 'layout(binding = 6) buffer windepthsbuffer { float olddepth; float windepths[4000000]; };'
   db 'void main()'
   db '{'
   db 'uint x = uint(gl_FragCoord.x - 0.5);'
   db 'uint y = uint(gl_FragCoord.y - 0.5);'
   db 'uint xy = x + y * 2000;'
   db 'if (winclear) { wincoords[xy] = 0u; windepths[xy] = 0.0f; }'
   db 'else if (doorcheck) { if (olddepth < 10 && windepths[xy] > 10) { w = wincoords[xy]; } olddepth = windepths[xy]; }'
   db 'else if (iswindow && vertw == w && windepths[xy] < gl_FragCoord.w) { wincoords[xy] = fragwinw; windepths[xy] = gl_FragCoord.w; }'
   db 'else if (vertw == w && windepths[xy] < gl_FragCoord.w) { fragColor = vec4(1.0, 0.0, 0.0, 0.0); return; }'
   db 'else if (wincoords[xy] == vertw && windepths[xy] > gl_FragCoord.w && !iswindow) { fragColor = vec4(1.0, 0.0, 0.0, 0.0); return; }'
   db 'discard;'
   db '}', 0

 ; Float constants
  zero dd 0.0 
  n1 dd -1.0
  p10th dd +0.10
  n10th dd -0.10
  p20th dd +0.05
  n20th dd -0.05
  p50th dd +0.02
  n50th dd -0.02

 ; Uniforms
  screenres.name db 'screenres', 0
  campos.name db 'campos', 0
  camangle.name db 'camangle', 0
  winclear.name db 'winclear', 0
  iswindow.name db 'iswindow', 0
  doorcheck.name db 'doorcheck', 0
  vertw.name db 'vertw', 0

  screenres.handle dd 0
  campos.handle dd 0
  camangle.handle dd 0
  winclear.handle dd 0
  iswindow.handle dd 0
  doorcheck.handle dd 0
  vertw.handle dd 0

  screenres dd 1600.0, 900.0
  campos dd 0.0, 5.5, +65.0
  camangle dd 0.0, 0.0, 0.0

 ; Handles
  window dq 0 ; Does this need to be 8 bytes?
  shader dd 0
  vao.ln dd 0
  vao.ll dd 0
  vao.ls dd 0
  vao.tr dd 0
  vao.pt dd 0
  vbo.ln dd 0
  vbo.ll dd 0
  vbo.ls dd 0
  vbo.tr dd 0
  vbo.pt dd 0
  ebo.ln dd 0
  ebo.ll dd 0
  ebo.ls dd 0
  ebo.tr dd 0
  sbo.wc dd 0
  sbo.dp dd 0

 ; Rooms
  ; Index is dimension
  roomcount dd 13
  pointerlist:
   r_0.pl:
    dd 0 ; Render pointer
    dd 0 ; Count
    dd 0 ; Angle pointer
    dd 0 ; Count
   r_1.pl:
    dd r_1.rl
    dd 13
    dd 0
    dd 0
   r_2.pl:
    dd r_2.rl
    dd 2
    dd 0
    dd 0
   r_3.pl:
    dd r_3.rl
    dd 2
    dd 0
    dd 0
   r_4.pl:
    dd r_4.rl
    dd 2
    dd 0
    dd 0
   r_5.pl:
    dd r_5.rl
    dd 2
    dd 0
    dd 0
   r_6.pl:
    dd r_6.rl
    dd 2
    dd 0
    dd 0
   r_7.pl:
    dd r_7.rl
    dd 2
    dd 0
    dd 0
   r_8.pl:
    dd r_8.rl
    dd 2
    dd 0
    dd 0
   r_9.pl:
    dd r_9.rl
    dd 2
    dd 0
    dd 0
   r_10.pl:
    dd r_10.rl
    dd 2
    dd 0
    dd 0
   r_11.pl:
    dd r_11.rl
    dd 2
    dd 0
    dd 0
   r_12.pl:
    dd r_12.rl
    dd 2
    dd 0
    dd 0
   r_13.pl:
    dd r_13.rl
    dd 2
    dd 0
    dd 0
  renderlist:
   r_0.rl:
   r_1.rl dd r_1, r_2, r_3, r_4, r_5, r_6, r_7, r_8, r_9, r_10, r_11, r_12, r_13
   r_2.rl dd r_2, r_1
   r_3.rl dd r_3, r_1
   r_4.rl dd r_4, r_1
   r_5.rl dd r_5, r_1
   r_6.rl dd r_6, r_1
   r_7.rl dd r_7, r_1
   r_8.rl dd r_8, r_1
   r_9.rl dd r_9, r_1
   r_10.rl dd r_10, r_1
   r_11.rl dd r_11, r_1
   r_12.rl dd r_12, r_1
   r_13.rl dd r_13, r_1
  angles:
   r_0.an: ; First 3 values are the rotational center, next 3 are the angle in radians. Center is offset by room position.
   r_1.an:
   r_2.an:
  rooms:
   ;r_0: ; Dimension 0 is special and never used
    ; 0 ; dd 0 ; w
    ; 4 ; dd 0 ; Doors counts index
    ; 8 ; dd 0 ; Doors indices index
    ; 12 ; dd 0 ; Doors render count
    ; 16 ; dd 0 ; Doors vertice pointer
    ; 20 ; dd 0 ; Doors vertice count
    ; 24 ; dd 0 ; Lines counts index
    ; 28 ; dd 0 ; Lines indices index
    ; 32 ; dd 0 ; Lines render count
    ; 36 ; dd 0 ; Lines vertice pointer
    ; 40 ; dd 0 ; Lines vertice count
    ; 44 ; dd 0 ; Lineloop count index
    ; 48 ; dd 0 ; Lineloop indices index
    ; 52 ; dd 0 ; Lineloop render count
    ; 56 ; dd 0 ; Lineloop vertice pointer
    ; 60 ; dd 0 ; Lineloop vertice count
    ; 64 ; dd 0 ; Linestrips counts index
    ; 68 ; dd 0 ; Linestrips indices index
    ; 72 ; dd 0 ; Linestrips render count
    ; 76 ; dd 0 ; Linestrips vertice pointer
    ; 80 ; dd 0 ; Linestrip vertice count
    ; 84 ; dd 0.0 ; Offset x
    ; 88 ; dd 0.0 ; Offset y
    ; 92 ; dd 0.0 ; Offset z
   r_1:
    dd 1 
    dd r_1.triangles.counts
    dd r_1.triangles.indices
    dd (r_1.triangles.counts.end-r_1.triangles.counts)/4
    dd r_1.triangles.vertices
    dd (r_1.triangles.vertices.end-r_1.triangles.vertices)/4/4
    dd r_1.lines.counts
    dd r_1.lines.indices
    dd (r_1.lines.counts.end-r_1.lines.counts)/4
    dd r_1.lines.vertices
    dd (r_1.lines.vertices.end-r_1.lines.vertices)/4/3
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0.0
    dd 0.0
    dd 0.0
   r_2:
    dd 2 
    dd r_2.triangles.counts
    dd r_2.triangles.indices
    dd (r_2.triangles.counts.end-r_2.triangles.counts)/4
    dd r_2.triangles.vertices
    dd (r_2.triangles.vertices.end-r_2.triangles.vertices)/4/4
    dd r_2.lines.counts
    dd r_2.lines.indices
    dd (r_2.lines.counts.end-r_2.lines.counts)/4
    dd r_2.lines.vertices
    dd (r_2.lines.vertices.end-r_2.lines.vertices)/4/3
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0.0
    dd 0.0
    dd 0.0
   r_3:
    dd 3 
    dd r_3.triangles.counts
    dd r_3.triangles.indices
    dd (r_3.triangles.counts.end-r_3.triangles.counts)/4
    dd r_3.triangles.vertices
    dd (r_3.triangles.vertices.end-r_3.triangles.vertices)/4/4
    dd r_3.lines.counts
    dd r_3.lines.indices
    dd (r_3.lines.counts.end-r_3.lines.counts)/4
    dd r_3.lines.vertices
    dd (r_3.lines.vertices.end-r_3.lines.vertices)/4/3
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0.0
    dd 0.0
    dd 0.0
   r_4:
    dd 4 
    dd r_4.triangles.counts
    dd r_4.triangles.indices
    dd (r_4.triangles.counts.end-r_4.triangles.counts)/4
    dd r_4.triangles.vertices
    dd (r_4.triangles.vertices.end-r_4.triangles.vertices)/4/4
    dd r_4.lines.counts
    dd r_4.lines.indices
    dd (r_4.lines.counts.end-r_4.lines.counts)/4
    dd r_4.lines.vertices
    dd (r_4.lines.vertices.end-r_4.lines.vertices)/4/3
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0.0
    dd 0.0
    dd 0.0
   r_5:
    dd 5 
    dd r_5.triangles.counts
    dd r_5.triangles.indices
    dd (r_5.triangles.counts.end-r_5.triangles.counts)/4
    dd r_5.triangles.vertices
    dd (r_5.triangles.vertices.end-r_5.triangles.vertices)/4/4
    dd r_5.lines.counts
    dd r_5.lines.indices
    dd (r_5.lines.counts.end-r_5.lines.counts)/4
    dd r_5.lines.vertices
    dd (r_5.lines.vertices.end-r_5.lines.vertices)/4/3
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0.0
    dd 0.0
    dd 19.0
   r_6:
    dd 6 
    dd r_6.triangles.counts
    dd r_6.triangles.indices
    dd (r_6.triangles.counts.end-r_6.triangles.counts)/4
    dd r_6.triangles.vertices
    dd (r_6.triangles.vertices.end-r_6.triangles.vertices)/4/4
    dd r_6.lines.counts
    dd r_6.lines.indices
    dd (r_6.lines.counts.end-r_6.lines.counts)/4
    dd r_6.lines.vertices
    dd (r_6.lines.vertices.end-r_6.lines.vertices)/4/3
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0.0
    dd 0.0
    dd 19.0
   r_7:
    dd 7 
    dd r_7.triangles.counts
    dd r_7.triangles.indices
    dd (r_7.triangles.counts.end-r_7.triangles.counts)/4
    dd r_7.triangles.vertices
    dd (r_7.triangles.vertices.end-r_7.triangles.vertices)/4/4
    dd r_7.lines.counts
    dd r_7.lines.indices
    dd (r_7.lines.counts.end-r_7.lines.counts)/4
    dd r_7.lines.vertices
    dd (r_7.lines.vertices.end-r_7.lines.vertices)/4/3
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0.0
    dd 0.0
    dd 38.0
   r_8:
    dd 8 
    dd r_8.triangles.counts
    dd r_8.triangles.indices
    dd (r_8.triangles.counts.end-r_8.triangles.counts)/4
    dd r_8.triangles.vertices
    dd (r_8.triangles.vertices.end-r_8.triangles.vertices)/4/4
    dd r_8.lines.counts
    dd r_8.lines.indices
    dd (r_8.lines.counts.end-r_8.lines.counts)/4
    dd r_8.lines.vertices
    dd (r_8.lines.vertices.end-r_8.lines.vertices)/4/3
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0.0
    dd 0.0
    dd 38.0
   r_9:
    dd 9 
    dd r_9.triangles.counts
    dd r_9.triangles.indices
    dd (r_9.triangles.counts.end-r_9.triangles.counts)/4
    dd r_9.triangles.vertices
    dd (r_9.triangles.vertices.end-r_9.triangles.vertices)/4/4
    dd r_9.lines.counts
    dd r_9.lines.indices
    dd (r_9.lines.counts.end-r_9.lines.counts)/4
    dd r_9.lines.vertices
    dd (r_9.lines.vertices.end-r_9.lines.vertices)/4/3
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0.0
    dd 0.0
    dd 57.0
   r_10:
    dd 10 
    dd r_10.triangles.counts
    dd r_10.triangles.indices
    dd (r_10.triangles.counts.end-r_10.triangles.counts)/4
    dd r_10.triangles.vertices
    dd (r_10.triangles.vertices.end-r_10.triangles.vertices)/4/4
    dd r_10.lines.counts
    dd r_10.lines.indices
    dd (r_10.lines.counts.end-r_10.lines.counts)/4
    dd r_10.lines.vertices
    dd (r_10.lines.vertices.end-r_10.lines.vertices)/4/3
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0.0
    dd 0.0
    dd 57.0
   r_11:
    dd 11 
    dd r_11.triangles.counts
    dd r_11.triangles.indices
    dd (r_11.triangles.counts.end-r_11.triangles.counts)/4
    dd r_11.triangles.vertices
    dd (r_11.triangles.vertices.end-r_11.triangles.vertices)/4/4
    dd r_11.lines.counts
    dd r_11.lines.indices
    dd (r_11.lines.counts.end-r_11.lines.counts)/4
    dd r_11.lines.vertices
    dd (r_11.lines.vertices.end-r_11.lines.vertices)/4/3
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0.0
    dd 0.0
    dd 76.0
   r_12:
    dd 12 
    dd r_12.triangles.counts
    dd r_12.triangles.indices
    dd (r_12.triangles.counts.end-r_12.triangles.counts)/4
    dd r_12.triangles.vertices
    dd (r_12.triangles.vertices.end-r_12.triangles.vertices)/4/4
    dd r_12.lines.counts
    dd r_12.lines.indices
    dd (r_12.lines.counts.end-r_12.lines.counts)/4
    dd r_12.lines.vertices
    dd (r_12.lines.vertices.end-r_12.lines.vertices)/4/3
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0.0
    dd 0.0
    dd 76.0
   r_13:
    dd 13 
    dd r_13.triangles.counts
    dd r_13.triangles.indices
    dd (r_13.triangles.counts.end-r_13.triangles.counts)/4
    dd r_13.triangles.vertices
    dd (r_13.triangles.vertices.end-r_13.triangles.vertices)/4/4
    dd r_13.lines.counts
    dd r_13.lines.indices
    dd (r_13.lines.counts.end-r_13.lines.counts)/4
    dd r_13.lines.vertices
    dd (r_13.lines.vertices.end-r_13.lines.vertices)/4/3
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0.0
    dd 0.0
    dd 0.0

 ; Vertice data
  ; Definitions
   %define r_1.w 1
   %define r_2.w 2
   %define r_3.w 3
   %define r_4.w 4
   %define r_5.w 5
   %define r_6.w 6
   %define r_7.w 7
   %define r_8.w 8
   %define r_9.w 9
   %define r_10.w 10
   %define r_11.w 11
   %define r_12.w 12
   %define r_13.w 13
  ; Points
   points dd 0.0, 0.0, 0.0
  ; Triangles
   triangles:
    wcv ywinv -1.0, -1.0, +0.0, +1.0, +1.0, +0.0, 0
    r_1.triangles.vertices:
     r_1.door1v ywinv -01.85, +00.05, -25.00, +00.85, +06.00, -25.00, r_2.w
     r_1.door2v ywinv -04.00, +00.05, -16.85, -04.00, +06.00, -14.15, r_3.w
     r_1.door3v ywinv +03.00, +00.05, -16.85, +03.00, +06.00, -14.15, r_4.w
     r_1.door4v ywinv -04.00, +00.05, +02.15, -04.00, +06.00, +04.85, r_5.w
     r_1.door5v ywinv +03.00, +00.05, +02.15, +03.00, +06.00, +04.85, r_6.w
     r_1.door6v ywinv -04.00, +00.05, +21.15, -04.00, +06.00, +23.85, r_7.w
     r_1.door7v ywinv +03.00, +00.05, +21.15, +03.00, +06.00, +23.85, r_8.w
     r_1.door8v ywinv -04.00, +00.05, +40.15, -04.00, +06.00, +42.85, r_9.w
     r_1.door9v ywinv +03.00, +00.05, +40.15, +03.00, +06.00, +42.85, r_10.w
     r_1.door10v ywinv -04.00, +00.05, +59.15, -04.00, +06.00, +61.85, r_11.w
     r_1.door11v ywinv +03.00, +00.05, +59.15, +03.00, +06.00, +61.85, r_12.w
     r_1.door12v ywinv -01.85, +00.05, +70.00, +00.85, +06.00, +70.00, r_13.w
     r_1.triangles.vertices.end:
    r_2.triangles.vertices:
     r_2.door1v ywinv -01.85, +00.05, -25.00, +00.85, +06.00, -25.00, r_1.w
     r_2.triangles.vertices.end:
    r_3.triangles.vertices:
     r_3.door1v ywinv -04.00, +00.05, -16.85, -04.00, +06.00, -14.15, r_1.w
     r_3.triangles.vertices.end:
    r_4.triangles.vertices:
     r_4.door1v ywinv +03.00, +00.05, -16.85, +03.00, +06.00, -14.15, r_1.w
     r_4.triangles.vertices.end:
    r_5.triangles.vertices:
     r_5.door1v ywinv -04.00, +00.05, -16.85, -04.00, +06.00, -14.15, r_1.w
     r_5.triangles.vertices.end:
    r_6.triangles.vertices:
     r_6.door1v ywinv +03.00, +00.05, -16.85, +03.00, +06.00, -14.15, r_1.w
     r_6.triangles.vertices.end:
    r_7.triangles.vertices:
     r_7.door1v ywinv -04.00, +00.05, -16.85, -04.00, +06.00, -14.15, r_1.w
     r_7.triangles.vertices.end:
    r_8.triangles.vertices:
     r_8.door1v ywinv +03.00, +00.05, -16.85, +03.00, +06.00, -14.15, r_1.w
     r_8.triangles.vertices.end:
    r_9.triangles.vertices:
     r_9.door1v ywinv -04.00, +00.05, -16.85, -04.00, +06.00, -14.15, r_1.w
     r_9.triangles.vertices.end:
    r_10.triangles.vertices:
     r_10.door1v ywinv +03.00, +00.05, -16.85, +03.00, +06.00, -14.15, r_1.w
     r_10.triangles.vertices.end:
    r_11.triangles.vertices:
     r_11.door1v ywinv -04.00, +00.05, -16.85, -04.00, +06.00, -14.15, r_1.w
     r_11.triangles.vertices.end:
    r_12.triangles.vertices:
     r_12.door1v ywinv +03.00, +00.05, +59.15, +03.00, +06.00, +61.85, r_1.w
     r_12.triangles.vertices.end:
    r_13.triangles.vertices:
     r_13.door1v ywinv -01.85, +00.05, +70.00, +00.85, +06.00, +70.00, r_1.w
     r_13.triangles.vertices.end: 
    triangles.end:
   triangles.elements:
    wce ywine (wcv-triangles)/4/4
    r_1.triangles.elements:
     r_1.door1e ywine (r_1.door1v-triangles)/4/4
     r_1.door2e ywine (r_1.door2v-triangles)/4/4
     r_1.door3e ywine (r_1.door3v-triangles)/4/4
     r_1.door4e ywine (r_1.door4v-triangles)/4/4
     r_1.door5e ywine (r_1.door5v-triangles)/4/4
     r_1.door6e ywine (r_1.door6v-triangles)/4/4
     r_1.door7e ywine (r_1.door7v-triangles)/4/4
     r_1.door8e ywine (r_1.door8v-triangles)/4/4
     r_1.door9e ywine (r_1.door9v-triangles)/4/4
     r_1.door10e ywine (r_1.door10v-triangles)/4/4
     r_1.door11e ywine (r_1.door11v-triangles)/4/4
     r_1.door12e ywine (r_1.door12v-triangles)/4/4
    r_2.triangles.elements:
     r_2.door1e ywine (r_2.door1v-triangles)/4/4
    r_3.triangles.elements:
     r_3.door1e ywine (r_3.door1v-triangles)/4/4
    r_4.triangles.elements:
     r_4.door1e ywine (r_4.door1v-triangles)/4/4
    r_5.triangles.elements:
     r_5.door1e ywine (r_5.door1v-triangles)/4/4
    r_6.triangles.elements:
     r_6.door1e ywine (r_6.door1v-triangles)/4/4
    r_7.triangles.elements:
     r_7.door1e ywine (r_7.door1v-triangles)/4/4
    r_8.triangles.elements:
     r_8.door1e ywine (r_8.door1v-triangles)/4/4
    r_9.triangles.elements:
     r_9.door1e ywine (r_9.door1v-triangles)/4/4
    r_10.triangles.elements:
     r_10.door1e ywine (r_10.door1v-triangles)/4/4
    r_11.triangles.elements:
     r_11.door1e ywine (r_11.door1v-triangles)/4/4
    r_12.triangles.elements:
     r_12.door1e ywine (r_12.door1v-triangles)/4/4
    r_13.triangles.elements:
     r_13.door1e ywine (r_13.door1v-triangles)/4/4
    triangles.elements.end:
   triangles.indices:
    dq wce-triangles.elements
    r_1.triangles.indices:
     dq r_1.door1e-triangles.elements
     dq r_1.door2e-triangles.elements
     dq r_1.door3e-triangles.elements
     dq r_1.door4e-triangles.elements
     dq r_1.door5e-triangles.elements
     dq r_1.door6e-triangles.elements
     dq r_1.door7e-triangles.elements
     dq r_1.door8e-triangles.elements
     dq r_1.door9e-triangles.elements
     dq r_1.door10e-triangles.elements
     dq r_1.door11e-triangles.elements
     dq r_1.door12e-triangles.elements
    r_2.triangles.indices:
     dq r_2.door1e-triangles.elements
    r_3.triangles.indices:
     dq r_3.door1e-triangles.elements
    r_4.triangles.indices:
     dq r_4.door1e-triangles.elements
    r_5.triangles.indices:
     dq r_5.door1e-triangles.elements
    r_6.triangles.indices:
     dq r_6.door1e-triangles.elements
    r_7.triangles.indices:
     dq r_7.door1e-triangles.elements
    r_8.triangles.indices:
     dq r_8.door1e-triangles.elements
    r_9.triangles.indices:
     dq r_9.door1e-triangles.elements
    r_10.triangles.indices:
     dq r_10.door1e-triangles.elements
    r_11.triangles.indices:
     dq r_11.door1e-triangles.elements
    r_12.triangles.indices:
     dq r_12.door1e-triangles.elements
    r_13.triangles.indices:
     dq r_13.door1e-triangles.elements
   triangles.counts:
    dd 6
    r_1.triangles.counts:
     times 12 dd 6
     r_1.triangles.counts.end:
    r_2.triangles.counts:
     dd 6
     r_2.triangles.counts.end:
    r_3.triangles.counts:
     dd 6
     r_3.triangles.counts.end:
    r_4.triangles.counts:
     dd 6
     r_4.triangles.counts.end:
    r_5.triangles.counts:
     dd 6
     r_5.triangles.counts.end:
    r_6.triangles.counts:
     dd 6
     r_6.triangles.counts.end:
    r_7.triangles.counts:
     dd 6
     r_7.triangles.counts.end:
    r_8.triangles.counts:
     dd 6
     r_8.triangles.counts.end:
    r_9.triangles.counts:
     dd 6
     r_9.triangles.counts.end:
    r_10.triangles.counts:
     dd 6
     r_10.triangles.counts.end:
    r_11.triangles.counts:
     dd 6
     r_11.triangles.counts.end:
    r_12.triangles.counts:
     dd 6
     r_12.triangles.counts.end:
    r_13.triangles.counts:
     dd 6
     r_13.triangles.counts.end:
  ; Lines
   lines:
    r_1.lines.vertices: ; Hallway 1
     ; Cube outline
      ;dd -04.00, +00.00, -25.00, +03.00, +00.00, -25.00 ; Back wall bottom
      ;dd -04.00, +00.00, -25.00, -04.00, +00.00, +13.00 ; Left wall bottom
      ;dd +03.00, +00.00, -25.00, +03.00, +00.00, +13.00 ; Right wall bottom
      ;dd -04.00, +00.00, +13.00, +03.00, +00.00, +13.00 ; Front wall bottom
      ;dd -04.00, +08.00, -25.00, +03.00, +08.00, -25.00 ; Back wall top
      ;dd -04.00, +08.00, -25.00, -04.00, +08.00, +13.00 ; Left wall top
      ;dd +03.00, +08.00, -25.00, +03.00, +08.00, +13.00 ; Right wall top
      ;dd -04.00, +08.00, +13.00, +03.00, +08.00, +13.00 ; Front wall top
      dd -04.00, +00.50, -25.00, -04.00, +07.95, -25.00 ; Back wall left
      dd +03.00, +00.50, -25.00, +03.00, +07.95, -25.00 ; Back wall right
      dd -04.00, +00.50, +70.00, -04.00, +07.95, +70.00 ; Front wall left
      dd +03.00, +00.50, +70.00, +03.00, +07.95, +70.00 ; Front wall right
     ; Baseboard
      dd -04.00, +00.50, -25.00, -02.45, +00.50, -25.00 ; Baseboard back left
      dd -03.85, +00.50, -24.85, -02.45, +00.50, -24.85
      dd +01.45, +00.50, -25.00, +03.00, +00.50, -25.00 ; Baseboard back right
      dd +01.45, +00.50, -24.85, +02.85, +00.50, -24.85
      dd -04.00, +00.50, -25.00, -04.00, +00.50, -17.45 ; Baseboard left 1
      dd -03.85, +00.50, -24.85, -03.85, +00.50, -17.45 
      dd -04.00, +00.50, -13.55, -04.00, +00.50, +01.55 ; Baseboard left 2
      dd -03.85, +00.50, -13.55, -03.85, +00.50, +01.55
      dd -04.00, +00.50, +05.45, -04.00, +00.50, +20.55 ; Baseboard left 3
      dd -03.85, +00.50, +05.45, -03.85, +00.50, +20.55 
      dd -04.00, +00.50, +24.45, -04.00, +00.50, +39.55 ; Baseboard left 4
      dd -03.85, +00.50, +24.45, -03.85, +00.50, +39.55 
      dd -04.00, +00.50, +43.45, -04.00, +00.50, +58.55 ; Baseboard left 5
      dd -03.85, +00.50, +43.45, -03.85, +00.50, +58.55
      dd -04.00, +00.50, +62.45, -04.00, +00.50, +70.00 ; Baseboard left 6
      dd -03.85, +00.50, +62.45, -03.85, +00.50, +69.85 
      dd +03.00, +00.50, -25.00, +03.00, +00.50, -17.45 ; Baseboard right 1
      dd +02.85, +00.50, -24.85, +02.85, +00.50, -17.45 
      dd +03.00, +00.50, -13.55, +03.00, +00.50, +01.55 ; Baseboard right 2
      dd +02.85, +00.50, -13.55, +02.85, +00.50, +01.55
      dd +03.00, +00.50, +05.45, +03.00, +00.50, +20.55 ; Baseboard right 3
      dd +02.85, +00.50, +05.45, +02.85, +00.50, +20.55 
      dd +03.00, +00.50, +24.45, +03.00, +00.50, +39.55 ; Baseboard right 4
      dd +02.85, +00.50, +24.45, +02.85, +00.50, +39.55 
      dd +03.00, +00.50, +43.45, +03.00, +00.50, +58.55 ; Baseboard right 5
      dd +02.85, +00.50, +43.45, +02.85, +00.50, +58.55
      dd +03.00, +00.50, +62.45, +03.00, +00.50, +70.00 ; Baseboard right 6
      dd +02.85, +00.50, +62.45, +02.85, +00.50, +69.85 
      dd -04.00, +00.50, +70.00, -02.45, +00.50, +70.00 ; Baseboard front left
      dd -03.85, +00.50, +69.85, -02.45, +00.50, +69.85
      dd +01.45, +00.50, +70.00, +03.00, +00.50, +70.00 ; Baseboard front right
      dd +01.45, +00.50, +69.85, +02.85, +00.50, +69.85
     ; Quarter mould
      dd -03.78, +00.00, -24.78, +02.78, +00.00, -24.78 ; Quarter mould back
      dd -03.85, +00.05, -24.85, +02.85, +00.05, -24.85
      dd -03.78, +00.00, -24.78, -03.78, +00.00, +69.78 ; Quarter mould left
      dd -03.85, +00.05, -24.85, -03.85, +00.05, +69.85 
      dd -03.78, +00.00, +69.78, +02.78, +00.00, +69.78 ; Quarter mould front
      dd -03.85, +00.05, +69.85, +02.85, +00.05, +69.85
      dd +02.78, +00.00, +69.78, +02.78, +00.00, -24.78 ; Quarter mould right
      dd +02.85, +00.05, +69.85, +02.85, +00.05, -24.85
     ; Dado rail
      dd -04.00, +03.15, -25.00, -02.45, +03.15, -25.00 ; Dado rail back left
      dd -04.00, +03.11, -25.00, -02.45, +03.11, -25.00
      dd -04.00, +03.04, -25.00, -02.45, +03.04, -25.00
      dd -04.00, +03.00, -25.00, -02.45, +03.00, -25.00
      dd +01.45, +03.15, -25.00, +03.00, +03.15, -25.00 ; Dado rail back right
      dd +01.45, +03.11, -25.00, +03.00, +03.11, -25.00
      dd +01.45, +03.04, -25.00, +03.00, +03.04, -25.00
      dd +01.45, +03.00, -25.00, +03.00, +03.00, -25.00
      dd -04.00, +03.15, -25.00, -04.00, +03.15, -17.45 ; Dado rail left 1
      dd -04.00, +03.11, -25.00, -04.00, +03.11, -17.45
      dd -04.00, +03.04, -25.00, -04.00, +03.04, -17.45
      dd -04.00, +03.00, -25.00, -04.00, +03.00, -17.45
      dd -04.00, +03.15, -13.55, -04.00, +03.15, +01.55 ; Dado rail left 2
      dd -04.00, +03.11, -13.55, -04.00, +03.11, +01.55
      dd -04.00, +03.04, -13.55, -04.00, +03.04, +01.55
      dd -04.00, +03.00, -13.55, -04.00, +03.00, +01.55
      dd -04.00, +03.15, +05.45, -04.00, +03.15, +20.55 ; Dado rail left 3
      dd -04.00, +03.11, +05.45, -04.00, +03.11, +20.55
      dd -04.00, +03.04, +05.45, -04.00, +03.04, +20.55
      dd -04.00, +03.00, +05.45, -04.00, +03.00, +20.55
      dd -04.00, +03.15, +24.45, -04.00, +03.15, +39.55 ; Dado rail left 4
      dd -04.00, +03.11, +24.45, -04.00, +03.11, +39.55
      dd -04.00, +03.04, +24.45, -04.00, +03.04, +39.55
      dd -04.00, +03.00, +24.45, -04.00, +03.00, +39.55
      dd -04.00, +03.15, +43.45, -04.00, +03.15, +58.55 ; Dado rail left 5
      dd -04.00, +03.11, +43.45, -04.00, +03.11, +58.55
      dd -04.00, +03.04, +43.45, -04.00, +03.04, +58.55
      dd -04.00, +03.00, +43.45, -04.00, +03.00, +58.55
      dd -04.00, +03.15, +62.45, -04.00, +03.15, +70.00 ; Dado rail left 6
      dd -04.00, +03.11, +62.45, -04.00, +03.11, +70.00
      dd -04.00, +03.04, +62.45, -04.00, +03.04, +70.00
      dd -04.00, +03.00, +62.45, -04.00, +03.00, +70.00
      dd +03.00, +03.15, -25.00, +03.00, +03.15, -17.45 ; Dado rail right 1
      dd +03.00, +03.11, -25.00, +03.00, +03.11, -17.45
      dd +03.00, +03.04, -25.00, +03.00, +03.04, -17.45
      dd +03.00, +03.00, -25.00, +03.00, +03.00, -17.45
      dd +03.00, +03.15, -13.55, +03.00, +03.15, +01.55 ; Dado rail right 2
      dd +03.00, +03.11, -13.55, +03.00, +03.11, +01.55
      dd +03.00, +03.04, -13.55, +03.00, +03.04, +01.55
      dd +03.00, +03.00, -13.55, +03.00, +03.00, +01.55
      dd +03.00, +03.15, +05.45, +03.00, +03.15, +20.55 ; Dado rail right 3
      dd +03.00, +03.11, +05.45, +03.00, +03.11, +20.55
      dd +03.00, +03.04, +05.45, +03.00, +03.04, +20.55
      dd +03.00, +03.00, +05.45, +03.00, +03.00, +20.55
      dd +03.00, +03.15, +24.45, +03.00, +03.15, +39.55 ; Dado rail right 4
      dd +03.00, +03.11, +24.45, +03.00, +03.11, +39.55
      dd +03.00, +03.04, +24.45, +03.00, +03.04, +39.55
      dd +03.00, +03.00, +24.45, +03.00, +03.00, +39.55
      dd +03.00, +03.15, +43.45, +03.00, +03.15, +58.55 ; Dado rail right 5
      dd +03.00, +03.11, +43.45, +03.00, +03.11, +58.55
      dd +03.00, +03.04, +43.45, +03.00, +03.04, +58.55
      dd +03.00, +03.00, +43.45, +03.00, +03.00, +58.55
      dd +03.00, +03.15, +62.45, +03.00, +03.15, +70.00 ; Dado rail right 6
      dd +03.00, +03.11, +62.45, +03.00, +03.11, +70.00
      dd +03.00, +03.04, +62.45, +03.00, +03.04, +70.00
      dd +03.00, +03.00, +62.45, +03.00, +03.00, +70.00
      dd -04.00, +03.15, +70.00, -02.45, +03.15, +70.00 ; Dado rail front left
      dd -04.00, +03.11, +70.00, -02.45, +03.11, +70.00
      dd -04.00, +03.04, +70.00, -02.45, +03.04, +70.00
      dd -04.00, +03.00, +70.00, -02.45, +03.00, +70.00
      dd +01.45, +03.15, +70.00, +03.00, +03.15, +70.00 ; Dado rail front right
      dd +01.45, +03.11, +70.00, +03.00, +03.11, +70.00
      dd +01.45, +03.04, +70.00, +03.00, +03.04, +70.00
      dd +01.45, +03.00, +70.00, +03.00, +03.00, +70.00
     ; Crown Mould
      dd -03.92, +08.00, -24.92, +02.92, +08.00, -24.92 ; Crown mould back
      dd -04.00, +07.95, -25.00, +03.00, +07.95, -25.00
      dd -03.92, +08.00, -24.92, -03.92, +08.00, +69.92 ; Crown mould left
      dd -04.00, +07.95, -25.00, -04.00, +07.95, +70.00
      dd -03.92, +08.00, +69.92, +02.92, +08.00, +69.92 ; Crown mould front
      dd -04.00, +07.95, +70.00, +03.00, +07.95, +70.00
      dd +02.92, +08.00, +69.92, +02.92, +08.00, -24.92 ; Crown mould right
      dd +03.00, +07.95, +70.00, +03.00, +07.95, -25.00
     ; Rug
      dd -02.70, +00.08, -24.30, -02.70, +00.08, +69.30
      dd -02.70, +00.08, +69.30, +01.70, +00.08, +69.30
      dd +01.70, +00.08, +69.30, +01.70, +00.08, -24.30
      dd +01.70, +00.08, -24.30, -02.70, +00.08, -24.30
     ; Lights
     ; Rug pattern
     ; Wallpaper pattern
     ; Back door
      dd -01.85, +00.05, -25.00, -01.85, +06.00, -25.00 
      dd -01.85, +06.00, -25.00, +00.85, +06.00, -25.00
      dd +00.85, +06.00, -25.00, +00.85, +00.05, -25.00
      dd -02.45, +00.50, -25.00, -02.45, +06.60, -25.00
      dd -02.45, +06.60, -25.00, +01.45, +06.60, -25.00
      dd +01.45, +06.60, -25.00, +01.45, +00.50, -25.00
      dd -02.45, +00.50, -24.85, -02.45, +06.60, -24.85
      dd -02.45, +06.60, -24.85, +01.45, +06.60, -24.85
      dd +01.45, +06.60, -24.85, +01.45, +00.50, -24.85
      dd -01.85, +00.05, -25.00, -01.95, +00.05, -25.00
      dd -01.95, +00.05, -25.00, -01.95, +00.05, -24.85
      dd -01.95, +00.05, -24.85, -01.95, +06.10, -24.85
      dd -01.95, +06.10, -24.85, +00.95, +06.10, -24.85
      dd +00.95, +06.10, -24.85, +00.95, +00.05, -24.85
      dd +00.95, +00.05, -24.85, +00.95, +00.05, -25.00
      dd +00.95, +00.05, -25.00, +00.85, +00.05, -25.00
      dd -01.95, +00.05, -25.00, -01.95, +06.10, -25.00
      dd -01.95, +06.10, -25.00, +00.95, +06.10, -25.00
      dd +00.95, +06.10, -25.00, +00.95, +00.05, -25.00
      dd -01.95, +06.10, -24.85, -01.95, +06.10, -25.00
      dd +00.95, +06.10, -24.85, +00.95, +06.10, -25.00
      dd -02.45, +06.60, -24.85, -02.45, +06.60, -25.00
      dd +01.45, +06.60, -24.85, +01.45, +06.60, -25.00
      ; Back door sign
     ; Left door 1
      dd -04.00, +00.05, -16.85, -04.00, +06.00, -16.85
      dd -04.00, +00.05, -14.15, -04.00, +06.00, -14.15
      dd -04.00, +06.00, -16.85, -04.00, +06.00, -14.15
      dd -04.00, +00.50, -17.45, -04.00, +06.60, -17.45
      dd -04.00, +06.60, -17.45, -04.00, +06.60, -13.55
      dd -04.00, +06.60, -13.55, -04.00, +00.50, -13.55
      dd -03.85, +00.50, -17.45, -03.85, +06.60, -17.45
      dd -03.85, +06.60, -17.45, -03.85, +06.60, -13.55
      dd -03.85, +06.60, -13.55, -03.85, +00.50, -13.55
      dd -04.00, +00.05, -16.85, -04.00, +00.05, -17.00
      dd -04.00, +00.05, -17.00, -03.85, +00.05, -17.00
      dd -04.00, +00.05, -17.00, -04.00, +06.10, -17.00
      dd -04.00, +06.10, -17.00, -04.00, +06.10, -14.00
      dd -04.00, +06.10, -14.00, -04.00, +00.05, -14.00
      dd -03.85, +00.05, -17.00, -03.85, +06.10, -17.00
      dd -03.85, +06.10, -17.00, -03.85, +06.10, -14.00
      dd -03.85, +06.10, -14.00, -03.85, +00.05, -14.00
      dd -03.85, +00.05, -14.00, -04.00, +00.05, -14.00
      dd -04.00, +00.05, -14.00, -04.00, +00.05, -14.15
      dd -03.85, +06.10, -14.00, -04.00, +06.10, -14.00
      dd -03.85, +06.10, -17.00, -04.00, +06.10, -17.00
      dd -03.85, +06.60, -13.55, -04.00, +06.60, -13.55
      dd -03.85, +06.60, -17.45, -04.00, +06.60, -17.45
     ; Left door 2
      dd -04.00, +00.05, +02.15, -04.00, +06.00, +02.15
      dd -04.00, +06.00, +02.15, -04.00, +06.00, +04.85
      dd -04.00, +06.00, +04.85, -04.00, +00.05, +04.85
      dd -04.00, +00.50, +01.55, -04.00, +06.60, +01.55
      dd -04.00, +06.60, +01.55, -04.00, +06.60, +05.45
      dd -04.00, +06.60, +05.45, -04.00, +00.50, +05.45
      dd -03.85, +00.50, +01.55, -03.85, +06.60, +01.55
      dd -03.85, +06.60, +01.55, -03.85, +06.60, +05.45
      dd -03.85, +06.60, +05.45, -03.85, +00.50, +05.45
      dd -04.00, +00.05, +02.15, -04.00, +00.05, +02.00
      dd -04.00, +00.05, +02.00, -03.85, +00.05, +02.00
      dd -04.00, +00.05, +02.00, -04.00, +06.10, +02.00
      dd -04.00, +06.10, +02.00, -04.00, +06.10, +05.00
      dd -04.00, +06.10, +05.00, -04.00, +00.05, +05.00
      dd -03.85, +00.05, +02.00, -03.85, +06.10, +02.00
      dd -03.85, +06.10, +02.00, -03.85, +06.10, +05.00
      dd -03.85, +06.10, +05.00, -03.85, +00.05, +05.00
      dd -03.85, +00.05, +05.00, -04.00, +00.05, +05.00
      dd -04.00, +00.05, +05.00, -04.00, +00.05, +04.85
      dd -03.85, +06.10, +05.00, -04.00, +06.10, +05.00
      dd -03.85, +06.10, +02.00, -04.00, +06.10, +02.00
      dd -03.85, +06.60, +05.45, -04.00, +06.60, +05.45
      dd -03.85, +06.60, +01.55, -04.00, +06.60, +01.55
     ; Left door 3
      dd -04.00, +00.05, +21.15, -04.00, +06.00, +21.15
      dd -04.00, +06.00, +21.15, -04.00, +06.00, +23.85
      dd -04.00, +06.00, +23.85, -04.00, +00.05, +23.85
      dd -04.00, +00.50, +20.55, -04.00, +06.60, +20.55
      dd -04.00, +06.60, +20.55, -04.00, +06.60, +24.45
      dd -04.00, +06.60, +24.45, -04.00, +00.50, +24.45
      dd -03.85, +00.50, +20.55, -03.85, +06.60, +20.55
      dd -03.85, +06.60, +20.55, -03.85, +06.60, +24.45
      dd -03.85, +06.60, +24.45, -03.85, +00.50, +24.45
      dd -04.00, +00.05, +21.15, -04.00, +00.05, +21.00
      dd -04.00, +00.05, +21.00, -03.85, +00.05, +21.00
      dd -04.00, +00.05, +21.00, -04.00, +06.10, +21.00
      dd -04.00, +06.10, +21.00, -04.00, +06.10, +24.00
      dd -04.00, +06.10, +24.00, -04.00, +00.05, +24.00
      dd -03.85, +00.05, +21.00, -03.85, +06.10, +21.00
      dd -03.85, +06.10, +21.00, -03.85, +06.10, +24.00
      dd -03.85, +06.10, +24.00, -03.85, +00.05, +24.00
      dd -03.85, +00.05, +24.00, -04.00, +00.05, +24.00
      dd -04.00, +00.05, +24.00, -04.00, +00.05, +23.85
      dd -03.85, +06.10, +24.00, -04.00, +06.10, +24.00
      dd -03.85, +06.10, +21.00, -04.00, +06.10, +21.00
      dd -03.85, +06.60, +24.45, -04.00, +06.60, +24.45
      dd -03.85, +06.60, +20.55, -04.00, +06.60, +20.55
     ; Left door 4
      dd -04.00, +00.05, +40.15, -04.00, +06.00, +40.15
      dd -04.00, +06.00, +40.15, -04.00, +06.00, +42.85
      dd -04.00, +06.00, +42.85, -04.00, +00.05, +42.85
      dd -04.00, +00.50, +39.55, -04.00, +06.60, +39.55
      dd -04.00, +06.60, +39.55, -04.00, +06.60, +43.45
      dd -04.00, +06.60, +43.45, -04.00, +00.50, +43.45
      dd -03.85, +00.50, +39.55, -03.85, +06.60, +39.55
      dd -03.85, +06.60, +39.55, -03.85, +06.60, +43.45
      dd -03.85, +06.60, +43.45, -03.85, +00.50, +43.45
      dd -04.00, +00.05, +40.15, -04.00, +00.05, +40.00
      dd -04.00, +00.05, +40.00, -03.85, +00.05, +40.00
      dd -04.00, +00.05, +40.00, -04.00, +06.10, +40.00
      dd -04.00, +06.10, +40.00, -04.00, +06.10, +43.00
      dd -04.00, +06.10, +43.00, -04.00, +00.05, +43.00
      dd -03.85, +00.05, +40.00, -03.85, +06.10, +40.00
      dd -03.85, +06.10, +40.00, -03.85, +06.10, +43.00
      dd -03.85, +06.10, +43.00, -03.85, +00.05, +43.00
      dd -03.85, +00.05, +43.00, -04.00, +00.05, +43.00
      dd -04.00, +00.05, +43.00, -04.00, +00.05, +42.85
      dd -03.85, +06.10, +43.00, -04.00, +06.10, +43.00
      dd -03.85, +06.10, +40.00, -04.00, +06.10, +40.00
      dd -03.85, +06.60, +43.45, -04.00, +06.60, +43.45
      dd -03.85, +06.60, +39.55, -04.00, +06.60, +39.55
     ; Left door 5
      dd -04.00, +00.05, +59.15, -04.00, +06.00, +59.15
      dd -04.00, +06.00, +59.15, -04.00, +06.00, +61.85
      dd -04.00, +06.00, +61.85, -04.00, +00.05, +61.85
      dd -04.00, +00.50, +58.55, -04.00, +06.60, +58.55
      dd -04.00, +06.60, +58.55, -04.00, +06.60, +62.45
      dd -04.00, +06.60, +62.45, -04.00, +00.50, +62.45
      dd -03.85, +00.50, +58.55, -03.85, +06.60, +58.55
      dd -03.85, +06.60, +58.55, -03.85, +06.60, +62.45
      dd -03.85, +06.60, +62.45, -03.85, +00.50, +62.45
      dd -04.00, +00.05, +59.15, -04.00, +00.05, +59.00
      dd -04.00, +00.05, +59.00, -03.85, +00.05, +59.00
      dd -04.00, +00.05, +59.00, -04.00, +06.10, +59.00
      dd -04.00, +06.10, +59.00, -04.00, +06.10, +62.00
      dd -04.00, +06.10, +62.00, -04.00, +00.05, +62.00
      dd -03.85, +00.05, +59.00, -03.85, +06.10, +59.00
      dd -03.85, +06.10, +59.00, -03.85, +06.10, +62.00
      dd -03.85, +06.10, +62.00, -03.85, +00.05, +62.00
      dd -03.85, +00.05, +62.00, -04.00, +00.05, +62.00
      dd -04.00, +00.05, +62.00, -04.00, +00.05, +61.85
      dd -03.85, +06.10, +62.00, -04.00, +06.10, +62.00
      dd -03.85, +06.10, +59.00, -04.00, +06.10, +59.00
      dd -03.85, +06.60, +62.45, -04.00, +06.60, +62.45
      dd -03.85, +06.60, +58.55, -04.00, +06.60, +58.55
     ; Right door 1
      dd +03.00, +00.05, -16.85, +03.00, +06.00, -16.85
      dd +03.00, +00.05, -14.15, +03.00, +06.00, -14.15
      dd +03.00, +06.00, -16.85, +03.00, +06.00, -14.15
      dd +02.85, +00.50, -17.45, +02.85, +06.60, -17.45
      dd +02.85, +06.60, -17.45, +02.85, +06.60, -13.55
      dd +02.85, +06.60, -13.55, +02.85, +00.50, -13.55
      dd +03.00, +00.50, -17.45, +03.00, +06.60, -17.45
      dd +03.00, +06.60, -17.45, +03.00, +06.60, -13.55
      dd +03.00, +06.60, -13.55, +03.00, +00.50, -13.55
      dd +03.00, +00.05, -16.85, +03.00, +00.05, -17.00
      dd +02.85, +00.05, -17.00, +03.00, +00.05, -17.00
      dd +02.85, +00.05, -17.00, +02.85, +06.10, -17.00
      dd +02.85, +06.10, -17.00, +02.85, +06.10, -14.00
      dd +02.85, +06.10, -14.00, +02.85, +00.05, -14.00
      dd +03.00, +00.05, -17.00, +03.00, +06.10, -17.00
      dd +03.00, +06.10, -17.00, +03.00, +06.10, -14.00
      dd +03.00, +06.10, -14.00, +03.00, +00.05, -14.00
      dd +03.00, +00.05, -14.00, +02.85, +00.05, -14.00
      dd +03.00, +00.05, -14.00, +03.00, +00.05, -14.15
      dd +02.85, +06.10, -14.00, +03.00, +06.10, -14.00
      dd +02.85, +06.10, -17.00, +03.00, +06.10, -17.00
      dd +02.85, +06.60, -13.55, +03.00, +06.60, -13.55
      dd +02.85, +06.60, -17.45, +03.00, +06.60, -17.45
     ; Right door 2
      dd +03.00, +00.05, +02.15, +03.00, +06.00, +02.15
      dd +03.00, +06.00, +02.15, +03.00, +06.00, +04.85
      dd +03.00, +06.00, +04.85, +03.00, +00.05, +04.85
      dd +02.85, +00.50, +01.55, +02.85, +06.60, +01.55
      dd +02.85, +06.60, +01.55, +02.85, +06.60, +05.45
      dd +02.85, +06.60, +05.45, +02.85, +00.50, +05.45
      dd +03.00, +00.50, +01.55, +03.00, +06.60, +01.55
      dd +03.00, +06.60, +01.55, +03.00, +06.60, +05.45
      dd +03.00, +06.60, +05.45, +03.00, +00.50, +05.45
      dd +03.00, +00.05, +04.85, +03.00, +00.05, +05.00
      dd +02.85, +00.05, +05.00, +03.00, +00.05, +05.00
      dd +02.85, +00.05, +05.00, +02.85, +06.10, +05.00
      dd +02.85, +06.10, +05.00, +02.85, +06.10, +02.00
      dd +02.85, +06.10, +02.00, +02.85, +00.05, +02.00
      dd +03.00, +00.05, +05.00, +03.00, +06.10, +05.00
      dd +03.00, +06.10, +05.00, +03.00, +06.10, +02.00
      dd +03.00, +06.10, +02.00, +03.00, +00.05, +02.00
      dd +03.00, +00.05, +02.00, +02.85, +00.05, +02.00
      dd +03.00, +00.05, +02.00, +03.00, +00.05, +02.15
      dd +02.85, +06.10, +05.00, +03.00, +06.10, +05.00
      dd +02.85, +06.10, +02.00, +03.00, +06.10, +02.00
      dd +02.85, +06.60, +05.45, +03.00, +06.60, +05.45
      dd +02.85, +06.60, +01.55, +03.00, +06.60, +01.55
     ; Right door 3
      dd +03.00, +00.05, +21.15, +03.00, +06.00, +21.15
      dd +03.00, +06.00, +21.15, +03.00, +06.00, +23.85
      dd +03.00, +06.00, +23.85, +03.00, +00.05, +23.85
      dd +02.85, +00.50, +20.55, +02.85, +06.60, +20.55
      dd +02.85, +06.60, +20.55, +02.85, +06.60, +24.45
      dd +02.85, +06.60, +24.45, +02.85, +00.50, +24.45
      dd +03.00, +00.50, +20.55, +03.00, +06.60, +20.55
      dd +03.00, +06.60, +20.55, +03.00, +06.60, +24.45
      dd +03.00, +06.60, +24.45, +03.00, +00.50, +24.45
      dd +03.00, +00.05, +23.85, +03.00, +00.05, +24.00
      dd +02.85, +00.05, +24.00, +03.00, +00.05, +24.00
      dd +02.85, +00.05, +24.00, +02.85, +06.10, +24.00
      dd +02.85, +06.10, +24.00, +02.85, +06.10, +21.00
      dd +02.85, +06.10, +21.00, +02.85, +00.05, +21.00
      dd +03.00, +00.05, +24.00, +03.00, +06.10, +24.00
      dd +03.00, +06.10, +24.00, +03.00, +06.10, +21.00
      dd +03.00, +06.10, +21.00, +03.00, +00.05, +21.00
      dd +03.00, +00.05, +21.00, +02.85, +00.05, +21.00
      dd +03.00, +00.05, +21.00, +03.00, +00.05, +21.15
      dd +02.85, +06.10, +24.00, +03.00, +06.10, +24.00
      dd +02.85, +06.10, +21.00, +03.00, +06.10, +21.00
      dd +02.85, +06.60, +24.45, +03.00, +06.60, +24.45
      dd +02.85, +06.60, +20.55, +03.00, +06.60, +20.55
     ; Right door 4
      dd +03.00, +00.05, +40.15, +03.00, +06.00, +40.15
      dd +03.00, +06.00, +40.15, +03.00, +06.00, +42.85
      dd +03.00, +06.00, +42.85, +03.00, +00.05, +42.85
      dd +02.85, +00.50, +39.55, +02.85, +06.60, +39.55
      dd +02.85, +06.60, +39.55, +02.85, +06.60, +43.45
      dd +02.85, +06.60, +43.45, +02.85, +00.50, +43.45
      dd +03.00, +00.50, +39.55, +03.00, +06.60, +39.55
      dd +03.00, +06.60, +39.55, +03.00, +06.60, +43.45
      dd +03.00, +06.60, +43.45, +03.00, +00.50, +43.45
      dd +03.00, +00.05, +42.85, +03.00, +00.05, +43.00
      dd +02.85, +00.05, +43.00, +03.00, +00.05, +43.00
      dd +02.85, +00.05, +43.00, +02.85, +06.10, +43.00
      dd +02.85, +06.10, +43.00, +02.85, +06.10, +40.00
      dd +02.85, +06.10, +40.00, +02.85, +00.05, +40.00
      dd +03.00, +00.05, +43.00, +03.00, +06.10, +43.00
      dd +03.00, +06.10, +43.00, +03.00, +06.10, +40.00
      dd +03.00, +06.10, +40.00, +03.00, +00.05, +40.00
      dd +03.00, +00.05, +40.00, +02.85, +00.05, +40.00
      dd +03.00, +00.05, +40.00, +03.00, +00.05, +40.15
      dd +02.85, +06.10, +43.00, +03.00, +06.10, +43.00
      dd +02.85, +06.10, +40.00, +03.00, +06.10, +40.00
      dd +02.85, +06.60, +43.45, +03.00, +06.60, +43.45
      dd +02.85, +06.60, +39.55, +03.00, +06.60, +39.55
     ; Right door 5
      dd +03.00, +00.05, +59.15, +03.00, +06.00, +59.15
      dd +03.00, +06.00, +59.15, +03.00, +06.00, +61.85
      dd +03.00, +06.00, +61.85, +03.00, +00.05, +61.85
      dd +02.85, +00.50, +58.55, +02.85, +06.60, +58.55
      dd +02.85, +06.60, +58.55, +02.85, +06.60, +62.45
      dd +02.85, +06.60, +62.45, +02.85, +00.50, +62.45
      dd +03.00, +00.50, +58.55, +03.00, +06.60, +58.55
      dd +03.00, +06.60, +58.55, +03.00, +06.60, +62.45
      dd +03.00, +06.60, +62.45, +03.00, +00.50, +62.45
      dd +03.00, +00.05, +61.85, +03.00, +00.05, +62.00
      dd +02.85, +00.05, +62.00, +03.00, +00.05, +62.00
      dd +02.85, +00.05, +62.00, +02.85, +06.10, +62.00
      dd +02.85, +06.10, +62.00, +02.85, +06.10, +59.00
      dd +02.85, +06.10, +59.00, +02.85, +00.05, +59.00
      dd +03.00, +00.05, +62.00, +03.00, +06.10, +62.00
      dd +03.00, +06.10, +62.00, +03.00, +06.10, +59.00
      dd +03.00, +06.10, +59.00, +03.00, +00.05, +59.00
      dd +03.00, +00.05, +59.00, +02.85, +00.05, +59.00
      dd +03.00, +00.05, +59.00, +03.00, +00.05, +59.15
      dd +02.85, +06.10, +62.00, +03.00, +06.10, +62.00
      dd +02.85, +06.10, +59.00, +03.00, +06.10, +59.00
      dd +02.85, +06.60, +62.45, +03.00, +06.60, +62.45
      dd +02.85, +06.60, +58.55, +03.00, +06.60, +58.55
     ; Front door
      dd -01.85, +00.05, +70.00, -01.85, +06.00, +70.00 
      dd -01.85, +06.00, +70.00, +00.85, +06.00, +70.00
      dd +00.85, +06.00, +70.00, +00.85, +00.05, +70.00
      dd -02.45, +00.50, +69.85, -02.45, +06.60, +69.85
      dd -02.45, +06.60, +69.85, +01.45, +06.60, +69.85
      dd +01.45, +06.60, +69.85, +01.45, +00.50, +69.85
      dd -02.45, +00.50, +70.00, -02.45, +06.60, +70.00
      dd -02.45, +06.60, +70.00, +01.45, +06.60, +70.00
      dd +01.45, +06.60, +70.00, +01.45, +00.50, +70.00
      dd -01.85, +00.05, +70.00, -01.95, +00.05, +70.00
      dd -01.95, +00.05, +69.85, -01.95, +00.05, +70.00
      dd -01.95, +00.05, +70.00, -01.95, +06.10, +70.00
      dd -01.95, +06.10, +70.00, +00.95, +06.10, +70.00
      dd +00.95, +06.10, +70.00, +00.95, +00.05, +70.00
      dd +00.95, +00.05, +70.00, +00.95, +00.05, +69.85
      dd +00.95, +00.05, +70.00, +00.85, +00.05, +70.00
      dd -01.95, +00.05, +69.85, -01.95, +06.10, +69.85
      dd -01.95, +06.10, +69.85, +00.95, +06.10, +69.85
      dd +00.95, +06.10, +69.85, +00.95, +00.05, +69.85
      dd -01.95, +06.10, +69.85, -01.95, +06.10, +70.00
      dd +00.95, +06.10, +69.85, +00.95, +06.10, +70.00
      dd -02.45, +06.60, +69.85, -02.45, +06.60, +70.00
      dd +01.45, +06.60, +69.85, +01.45, +06.60, +70.00
     ; Numbers
     r_1.lines.vertices.end:
    r_2.lines.vertices: ; Room 1
     ; Doorframe
      dd -01.85, +00.05, -25.00, -01.85, +06.00, -25.00 
      dd -01.85, +06.00, -25.00, +00.85, +06.00, -25.00
      dd +00.85, +06.00, -25.00, +00.85, +00.05, -25.00
      dd -01.85, +00.05, -25.00, -01.85, +00.05, -25.30
      dd +00.85, +00.05, -25.00, +00.85, +00.05, -25.30
      dd -02.00, +00.05, -25.45, +01.00, +00.05, -25.45
      dd -01.85, +00.05, -25.30, -01.85, +06.00, -25.30
      dd +00.85, +00.05, -25.30, +00.85, +06.00, -25.30
      dd -02.00, +06.00, -25.45, +01.00, +06.00, -25.45
      dd -01.85, +06.00, -25.00, -01.85, +06.00, -25.30
      dd +00.85, +06.00, -25.00, +00.85, +06.00, -25.30
      dd -01.85, +00.05, -25.30, -02.00, +00.05, -25.30
      dd -02.00, +00.05, -25.30, -02.00, +00.05, -25.45
      dd +00.85, +00.05, -25.30, +01.00, +00.05, -25.30
      dd +01.00, +00.05, -25.30, +01.00, +00.05, -25.45
      dd -02.00, +00.05, -25.30, -02.00, +06.00, -25.30
      dd +01.00, +00.05, -25.30, +01.00, +06.00, -25.30
      dd -02.00, +00.05, -25.45, -02.00, +06.00, -25.45
      dd +01.00, +00.05, -25.45, +01.00, +06.00, -25.45
      dd -01.85, +06.00, -25.30, -02.00, +06.00, -25.30
      dd -02.00, +06.00, -25.30, -02.00, +06.00, -25.45
      dd +00.85, +06.00, -25.30, +01.00, +06.00, -25.30
      dd +01.00, +06.00, -25.30, +01.00, +06.00, -25.45
     ; Door
      rprisml -01.98, +00.07, -25.32, +00.98, +05.98, -25.43 ; Door outline
      yrectl -01.50, +00.50, -25.32, -00.75, +02.75, -25.32 ; Door pattern (outer)
      yrectl +00.50, +00.50, -25.32, -00.25, +02.75, -25.32
      yrectl -01.50, +03.25, -25.32, -00.75, +05.50, -25.32
      yrectl +00.50, +03.25, -25.32, -00.25, +05.50, -25.32
      yrectl -01.45, +00.55, -25.35, -00.80, +02.70, -25.35
      yrectl +00.45, +00.55, -25.35, -00.20, +02.70, -25.35
      yrectl -01.45, +03.30, -25.35, -00.80, +05.45, -25.35
      yrectl +00.45, +03.30, -25.35, -00.20, +05.45, -25.35
      yrectl -01.35, +00.65, -25.35, -00.90, +02.60, -25.35
      yrectl +00.35, +00.65, -25.35, -00.10, +02.60, -25.35
      yrectl -01.35, +03.40, -25.35, -00.90, +05.35, -25.35
      yrectl +00.35, +03.40, -25.35, -00.10, +05.35, -25.35
      yrectl -01.30, +00.70, -25.32, -00.95, +02.55, -25.32
      yrectl +00.30, +00.70, -25.32, -00.05, +02.55, -25.32
      yrectl -01.30, +03.45, -25.32, -00.95, +05.30, -25.32
      yrectl +00.30, +03.45, -25.32, -00.05, +05.30, -25.32
      ;yrectl -01.50, +00.50, -25.40, -00.75, +02.75, -25.40 ; Inner
      ;yrectl +00.50, +00.50, -25.40, -00.25, +02.75, -25.40
      ;yrectl -01.50, +03.25, -25.40, -00.75, +05.50, -25.40
      ;yrectl +00.50, +03.25, -25.40, -00.25, +05.50, -25.40
      ;yrectl -01.45, +00.55, -25.43, -00.80, +02.70, -25.43
      ;yrectl +00.45, +00.55, -25.43, -00.20, +02.70, -25.43
      ;yrectl -01.45, +03.30, -25.43, -00.80, +05.45, -25.43
      ;yrectl +00.45, +03.30, -25.43, -00.20, +05.45, -25.43
      ;yrectl -01.35, +00.65, -25.43, -00.90, +02.60, -25.43
      ;yrectl +00.35, +00.65, -25.43, -00.10, +02.60, -25.43
      ;yrectl -01.35, +03.40, -25.43, -00.90, +05.35, -25.43
      ;yrectl +00.35, +03.40, -25.43, -00.10, +05.35, -25.43
      ;yrectl -01.30, +00.70, -25.40, -00.95, +02.55, -25.40
      ;yrectl +00.30, +00.70, -25.40, -00.05, +02.55, -25.40
      ;yrectl -01.30, +03.45, -25.40, -00.95, +05.30, -25.40
      ;yrectl +00.30, +03.45, -25.40, -00.05, +05.30, -25.40  
     ; Doorknob
      yrectl -01.75, +02.90, -25.32, -01.50, +03.10, -25.32 ; Outer
      dd -01.70, +02.95, -25.32, -01.70, +02.95, -25.02
      dd -01.70, +03.05, -25.32, -01.70, +03.05, -25.02
      dd -01.55, +02.95, -25.32, -01.55, +02.95, -25.10
      dd -01.55, +03.05, -25.32, -01.55, +03.05, -25.10
      dd -01.70, +02.95, -25.02, -01.20, +02.97, -25.04
      dd -01.70, +03.05, -25.02, -01.20, +03.03, -25.04
      dd -01.55, +02.95, -25.10, -01.20, +02.97, -25.08
      dd -01.55, +03.05, -25.10, -01.20, +03.03, -25.08
      yrectl -01.20, +02.97, -25.04, -01.20, +03.03, -25.08
      ;yrectl -01.75, +02.90, -25.43, -01.50, +03.10, -25.43 ; Inner
      ;dd -01.70, +02.95, -25.43, -01.70, +02.95, -25.81
      ;dd -01.70, +03.05, -25.43, -01.70, +03.05, -25.81
      ;dd -01.55, +02.95, -25.43, -01.55, +02.95, -25.73
      ;dd -01.55, +03.05, -25.43, -01.55, +03.05, -25.73
      ;dd -01.70, +02.95, -25.81, -01.20, +02.97, -25.79
      ;dd -01.70, +03.05, -25.81, -01.20, +03.03, -25.79
      ;dd -01.55, +02.95, -25.73, -01.20, +02.97, -25.75
      ;dd -01.55, +03.05, -25.73, -01.20, +03.03, -25.75
      ;yrectl -01.20, +02.97, -25.79, -01.20, +03.03, -25.75
     ; Hinge
     r_2.lines.vertices.end:
    r_3.lines.vertices: ; Room 2
     ; Doorframe
      dd -04.00, +00.05, -16.85, -04.00, +06.00, -16.85
      dd -04.00, +06.00, -16.85, -04.00, +06.00, -14.15
      dd -04.00, +06.00, -14.15, -04.00, +00.05, -14.15
      dd -04.00, +00.05, -16.85, -04.30, +00.05, -16.85
      dd -04.30, +00.05, -16.85, -04.30, +00.05, -17.00
      dd -04.30, +00.05, -17.00, -04.45, +00.06, -17.00
      dd -04.45, +00.05, -17.00, -04.45, +00.05, -14.00
      dd -04.45, +00.05, -14.00, -04.30, +00.05, -14.00
      dd -04.30, +00.05, -14.00, -04.30, +00.05, -14.15
      dd -04.30, +00.05, -14.15, -04.00, +00.05, -14.15
      dd -04.00, +06.00, -16.85, -04.30, +06.00, -16.85
      dd -04.30, +06.00, -16.85, -04.30, +06.00, -17.00
      dd -04.30, +06.00, -17.00, -04.45, +06.00, -17.00
      dd -04.45, +06.00, -17.00, -04.45, +06.00, -14.00
      dd -04.45, +06.00, -14.00, -04.30, +06.00, -14.00
      dd -04.30, +06.00, -14.00, -04.30, +06.00, -14.15
      dd -04.30, +06.00, -14.15, -04.00, +06.00, -14.15
      dd -04.30, +00.05, -16.85, -04.30, +06.00, -16.85
      dd -04.30, +00.05, -17.00, -04.30, +06.00, -17.00
      dd -04.45, +00.05, -17.00, -04.45, +06.00, -17.00
      dd -04.45, +00.05, -14.00, -04.45, +06.00, -14.00
      dd -04.30, +00.05, -14.00, -04.30, +06.00, -14.00
      dd -04.30, +00.05, -14.15, -04.30, +06.00, -14.15
     ; Door
      rprisml -04.32, +00.07, -16.98, -04.43, +05.98, -14.02
      yrectl -04.32, +00.50, -14.50, -04.32, +02.75, -15.25 ; Door pattern (outer)
      yrectl -04.32, +00.50, -16.50, -04.32, +02.75, -15.75
      yrectl -04.32, +03.25, -14.50, -04.32, +05.50, -15.25
      yrectl -04.32, +03.25, -16.50, -04.32, +05.50, -15.75
      yrectl -04.35, +00.55, -14.55, -04.35, +02.70, -15.20
      yrectl -04.35, +00.55, -16.45, -04.35, +02.70, -15.80
      yrectl -04.35, +03.30, -14.55, -04.35, +05.45, -15.20
      yrectl -04.35, +03.30, -16.45, -04.35, +05.45, -15.80
      yrectl -04.35, +00.65, -14.65, -04.35, +02.60, -15.10
      yrectl -04.35, +00.65, -16.35, -04.35, +02.60, -15.90
      yrectl -04.35, +03.40, -14.65, -04.35, +05.35, -15.10
      yrectl -04.35, +03.40, -16.35, -04.35, +05.35, -15.90
      yrectl -04.32, +00.70, -14.70, -04.32, +02.55, -15.05
      yrectl -04.32, +00.70, -16.30, -04.32, +02.55, -15.95
      yrectl -04.32, +03.45, -14.70, -04.32, +05.30, -15.05
      yrectl -04.32, +03.45, -16.30, -04.32, +05.30, -15.95
      ;yrectl -04.41, +00.50, -14.50, -04.41, +02.75, -15.25 ; Inner
      ;yrectl -04.41, +00.50, -16.50, -04.41, +02.75, -15.75
      ;yrectl -04.41, +03.25, -14.50, -04.41, +05.50, -15.25
      ;yrectl -04.41, +03.25, -16.50, -04.41, +05.50, -15.75
      ;yrectl -04.43, +00.55, -14.55, -04.43, +02.70, -15.20
      ;yrectl -04.43, +00.55, -16.45, -04.43, +02.70, -15.80
      ;yrectl -04.43, +03.30, -14.55, -04.43, +05.45, -15.20
      ;yrectl -04.43, +03.30, -16.45, -04.43, +05.45, -15.80
      ;yrectl -04.43, +00.65, -14.65, -04.43, +02.60, -15.10
      ;yrectl -04.43, +00.65, -16.35, -04.43, +02.60, -15.90
      ;yrectl -04.43, +03.40, -14.65, -04.43, +05.35, -15.10
      ;yrectl -04.43, +03.40, -16.35, -04.43, +05.35, -15.90
      ;yrectl -04.41, +00.70, -14.70, -04.41, +02.55, -15.05
      ;yrectl -04.41, +00.70, -16.30, -04.41, +02.55, -15.95
      ;yrectl -04.41, +03.45, -14.70, -04.41, +05.30, -15.05
      ;yrectl -04.41, +03.45, -16.30, -04.41, +05.30, -15.95
     ; Doorknob
      yrectl -04.32, +02.90, -14.25, -04.32, +03.10, -14.50 ; Outer
      dd -04.32, +02.95, -14.30, -04.02, +02.95, -14.30
      dd -04.32, +02.95, -14.45, -04.10, +02.95, -14.45
      dd -04.32, +03.05, -14.30, -04.02, +03.05, -14.30
      dd -04.32, +03.05, -14.45, -04.10, +03.05, -14.45
      dd -04.02, +02.95, -14.30, -04.04, +02.97, -14.80
      dd -04.10, +02.95, -14.45, -04.08, +02.97, -14.80
      dd -04.02, +03.05, -14.30, -04.04, +03.03, -14.80
      dd -04.10, +03.05, -14.45, -04.08, +03.03, -14.80
      yrectl -04.04, +02.97, -14.80, -04.08, +03.03, -14.80
      ;yrectl -04.43, +02.90, -14.25, -04.43, +03.10, -14.50 ; Inner
      ;dd -04.43, +02.95, -14.30, -04.73, +02.95, -14.30
      ;dd -04.43, +02.95, -14.45, -04.65, +02.95, -14.45
      ;dd -04.43, +03.05, -14.30, -04.73, +03.05, -14.30
      ;dd -04.43, +03.05, -14.45, -04.65, +03.05, -14.45
      ;dd -04.73, +02.95, -14.30, -04.71, +02.97, -14.80
      ;dd -04.65, +02.95, -14.45, -04.67, +02.97, -14.80
      ;dd -04.73, +03.05, -14.30, -04.71, +03.03, -14.80
      ;dd -04.65, +03.05, -14.45, -04.67, +03.03, -14.80
      ;yrectl -04.71, +02.97, -14.80, -04.67, +03.03, -14.80
     ; Hinge
     r_3.lines.vertices.end:
    r_4.lines.vertices: ; Room 3
     ; Doorframe
      dd +03.00, +00.05, -16.85, +03.00, +06.00, -16.85
      dd +03.00, +06.00, -16.85, +03.00, +06.00, -14.15
      dd +03.00, +06.00, -14.15, +03.00, +00.05, -14.15
      dd +03.00, +00.05, -16.85, +03.30, +00.05, -16.85
      dd +03.30, +00.05, -16.85, +03.30, +00.05, -17.00
      dd +03.30, +00.05, -17.00, +03.45, +00.05, -17.00
      dd +03.45, +00.05, -17.00, +03.45, +00.05, -14.00
      dd +03.45, +00.05, -14.00, +03.30, +00.05, -14.00
      dd +03.30, +00.05, -14.00, +03.30, +00.05, -14.15
      dd +03.30, +00.05, -14.15, +03.00, +00.05, -14.15
      dd +03.00, +06.00, -16.85, +03.30, +06.00, -16.85
      dd +03.30, +06.00, -16.85, +03.30, +06.00, -17.00
      dd +03.30, +06.00, -17.00, +03.45, +06.00, -17.00
      dd +03.45, +06.00, -17.00, +03.45, +06.00, -14.00
      dd +03.45, +06.00, -14.00, +03.30, +06.00, -14.00
      dd +03.30, +06.00, -14.00, +03.30, +06.00, -14.15
      dd +03.30, +06.00, -14.15, +03.00, +06.00, -14.15
      dd +03.30, +00.05, -16.85, +03.30, +06.00, -16.85
      dd +03.30, +00.05, -17.00, +03.30, +06.00, -17.00
      dd +03.45, +00.05, -17.00, +03.45, +06.00, -17.00
      dd +03.45, +00.05, -14.00, +03.45, +06.00, -14.00
      dd +03.30, +00.05, -14.00, +03.30, +06.00, -14.00
      dd +03.30, +00.05, -14.15, +03.30, +06.00, -14.15
     ; Door
      rprisml +03.32, +00.07, -16.98, +03.43, +05.98, -14.02
      yrectl +03.32, +00.50, -14.50, +03.32, +02.75, -15.25 ; Door pattern (outer)
      yrectl +03.32, +00.50, -16.50, +03.32, +02.75, -15.75
      yrectl +03.32, +03.25, -14.50, +03.32, +05.50, -15.25
      yrectl +03.32, +03.25, -16.50, +03.32, +05.50, -15.75
      yrectl +03.35, +00.55, -14.55, +03.35, +02.70, -15.20
      yrectl +03.35, +00.55, -16.45, +03.35, +02.70, -15.80
      yrectl +03.35, +03.30, -14.55, +03.35, +05.45, -15.20
      yrectl +03.35, +03.30, -16.45, +03.35, +05.45, -15.80
      yrectl +03.35, +00.65, -14.65, +03.35, +02.60, -15.10
      yrectl +03.35, +00.65, -16.35, +03.35, +02.60, -15.90
      yrectl +03.35, +03.40, -14.65, +03.35, +05.35, -15.10
      yrectl +03.35, +03.40, -16.35, +03.35, +05.35, -15.90
      yrectl +03.32, +00.70, -14.70, +03.32, +02.55, -15.05
      yrectl +03.32, +00.70, -16.30, +03.32, +02.55, -15.95
      yrectl +03.32, +03.45, -14.70, +03.32, +05.30, -15.05
      yrectl +03.32, +03.45, -16.30, +03.32, +05.30, -15.95
      ;yrectl +03.43, +00.50, -14.50, +03.43, +02.75, -15.25 ; Inner
      ;yrectl +03.43, +00.50, -16.50, +03.43, +02.75, -15.75
      ;yrectl +03.43, +03.25, -14.50, +03.43, +05.50, -15.25
      ;yrectl +03.43, +03.25, -16.50, +03.43, +05.50, -15.75
      ;yrectl +03.40, +00.55, -14.55, +03.40, +02.70, -15.20
      ;yrectl +03.40, +00.55, -16.45, +03.40, +02.70, -15.80
      ;yrectl +03.40, +03.30, -14.55, +03.40, +05.45, -15.20
      ;yrectl +03.40, +03.30, -16.45, +03.40, +05.45, -15.80
      ;yrectl +03.40, +00.65, -14.65, +03.40, +02.60, -15.10
      ;yrectl +03.40, +00.65, -16.35, +03.40, +02.60, -15.90
      ;yrectl +03.40, +03.40, -14.65, +03.40, +05.35, -15.10
      ;yrectl +03.40, +03.40, -16.35, +03.40, +05.35, -15.90
      ;yrectl +03.43, +00.70, -14.70, +03.43, +02.55, -15.05
      ;yrectl +03.43, +00.70, -16.30, +03.43, +02.55, -15.95
      ;yrectl +03.43, +03.45, -14.70, +03.43, +05.30, -15.05
      ;yrectl +03.43, +03.45, -16.30, +03.43, +05.30, -15.95
     ; Doorknob
      yrectl +03.32, +02.90, -14.25, +03.32, +03.10, -14.50 ; Outer
      dd +03.32, +02.95, -14.30, +03.02, +02.95, -14.30
      dd +03.32, +02.95, -14.45, +03.10, +02.95, -14.45
      dd +03.32, +03.05, -14.30, +03.02, +03.05, -14.30
      dd +03.32, +03.05, -14.45, +03.10, +03.05, -14.45
      dd +03.02, +02.95, -14.30, +03.04, +02.97, -14.80
      dd +03.10, +02.95, -14.45, +03.08, +02.97, -14.80
      dd +03.02, +03.05, -14.30, +03.04, +03.03, -14.80
      dd +03.10, +03.05, -14.45, +03.08, +03.03, -14.80
      yrectl +03.04, +02.97, -14.80, +03.08, +03.03, -14.80
      ;yrectl +03.43, +02.90, -14.25, +03.43, +03.10, -14.50 ; Inner
      ;dd +03.43, +02.95, -14.30, +03.73, +02.95, -14.30
      ;dd +03.43, +02.95, -14.45, +03.65, +02.95, -14.45
      ;dd +03.43, +03.05, -14.30, +03.73, +03.05, -14.30
      ;dd +03.43, +03.05, -14.45, +03.65, +03.05, -14.45
      ;dd +03.73, +02.95, -14.30, +03.71, +02.97, -14.80
      ;dd +03.65, +02.95, -14.45, +03.67, +02.97, -14.80
      ;dd +03.73, +03.05, -14.30, +03.71, +03.03, -14.80
      ;dd +03.65, +03.05, -14.45, +03.67, +03.03, -14.80
      ;yrectl +03.71, +02.97, -14.80, +03.67, +03.03, -14.80
     ; Hinge 
     r_4.lines.vertices.end:
    r_5.lines.vertices: ; Room 4 (stairway)
     ; Doorframe
      dd -04.00, +00.05, -16.85, -04.00, +06.00, -16.85
      dd -04.00, +06.00, -16.85, -04.00, +06.00, -14.15
      dd -04.00, +06.00, -14.15, -04.00, +00.05, -14.15
      dd -04.00, +00.05, -16.85, -04.30, +00.05, -16.85
      dd -04.30, +00.05, -16.85, -04.30, +00.05, -17.00
      dd -04.30, +00.05, -17.00, -04.45, +00.06, -17.00
      dd -04.45, +00.05, -17.00, -04.45, +00.05, -14.00
      dd -04.45, +00.05, -14.00, -04.30, +00.05, -14.00
      dd -04.30, +00.05, -14.00, -04.30, +00.05, -14.15
      dd -04.30, +00.05, -14.15, -04.00, +00.05, -14.15
      dd -04.00, +06.00, -16.85, -04.30, +06.00, -16.85
      dd -04.30, +06.00, -16.85, -04.30, +06.00, -17.00
      dd -04.30, +06.00, -17.00, -04.45, +06.00, -17.00
      dd -04.45, +06.00, -17.00, -04.45, +06.00, -14.00
      dd -04.45, +06.00, -14.00, -04.30, +06.00, -14.00
      dd -04.30, +06.00, -14.00, -04.30, +06.00, -14.15
      dd -04.30, +06.00, -14.15, -04.00, +06.00, -14.15
      dd -04.30, +00.05, -16.85, -04.30, +06.00, -16.85
      dd -04.30, +00.05, -17.00, -04.30, +06.00, -17.00
      dd -04.45, +00.05, -17.00, -04.45, +06.00, -17.00
      dd -04.45, +00.05, -14.00, -04.45, +06.00, -14.00
      dd -04.30, +00.05, -14.00, -04.30, +06.00, -14.00
      dd -04.30, +00.05, -14.15, -04.30, +06.00, -14.15
     ; Door
      rprisml -04.32, +00.07, -16.98, -04.43, +05.98, -14.02
      yrectl -04.32, +00.50, -14.50, -04.32, +02.75, -15.25 ; Door pattern (outer)
      yrectl -04.32, +00.50, -16.50, -04.32, +02.75, -15.75
      yrectl -04.32, +03.25, -14.50, -04.32, +05.50, -15.25
      yrectl -04.32, +03.25, -16.50, -04.32, +05.50, -15.75
      yrectl -04.35, +00.55, -14.55, -04.35, +02.70, -15.20
      yrectl -04.35, +00.55, -16.45, -04.35, +02.70, -15.80
      yrectl -04.35, +03.30, -14.55, -04.35, +05.45, -15.20
      yrectl -04.35, +03.30, -16.45, -04.35, +05.45, -15.80
      yrectl -04.35, +00.65, -14.65, -04.35, +02.60, -15.10
      yrectl -04.35, +00.65, -16.35, -04.35, +02.60, -15.90
      yrectl -04.35, +03.40, -14.65, -04.35, +05.35, -15.10
      yrectl -04.35, +03.40, -16.35, -04.35, +05.35, -15.90
      yrectl -04.32, +00.70, -14.70, -04.32, +02.55, -15.05
      yrectl -04.32, +00.70, -16.30, -04.32, +02.55, -15.95
      yrectl -04.32, +03.45, -14.70, -04.32, +05.30, -15.05
      yrectl -04.32, +03.45, -16.30, -04.32, +05.30, -15.95
      ;yrectl -04.41, +00.50, -14.50, -04.41, +02.75, -15.25 ; Inner
      ;yrectl -04.41, +00.50, -16.50, -04.41, +02.75, -15.75
      ;yrectl -04.41, +03.25, -14.50, -04.41, +05.50, -15.25
      ;yrectl -04.41, +03.25, -16.50, -04.41, +05.50, -15.75
      ;yrectl -04.43, +00.55, -14.55, -04.43, +02.70, -15.20
      ;yrectl -04.43, +00.55, -16.45, -04.43, +02.70, -15.80
      ;yrectl -04.43, +03.30, -14.55, -04.43, +05.45, -15.20
      ;yrectl -04.43, +03.30, -16.45, -04.43, +05.45, -15.80
      ;yrectl -04.43, +00.65, -14.65, -04.43, +02.60, -15.10
      ;yrectl -04.43, +00.65, -16.35, -04.43, +02.60, -15.90
      ;yrectl -04.43, +03.40, -14.65, -04.43, +05.35, -15.10
      ;yrectl -04.43, +03.40, -16.35, -04.43, +05.35, -15.90
      ;yrectl -04.41, +00.70, -14.70, -04.41, +02.55, -15.05
      ;yrectl -04.41, +00.70, -16.30, -04.41, +02.55, -15.95
      ;yrectl -04.41, +03.45, -14.70, -04.41, +05.30, -15.05
      ;yrectl -04.41, +03.45, -16.30, -04.41, +05.30, -15.95
     ; Doorknob
      yrectl -04.32, +02.90, -14.25, -04.32, +03.10, -14.50 ; Outer
      dd -04.32, +02.95, -14.30, -04.02, +02.95, -14.30
      dd -04.32, +02.95, -14.45, -04.10, +02.95, -14.45
      dd -04.32, +03.05, -14.30, -04.02, +03.05, -14.30
      dd -04.32, +03.05, -14.45, -04.10, +03.05, -14.45
      dd -04.02, +02.95, -14.30, -04.04, +02.97, -14.80
      dd -04.10, +02.95, -14.45, -04.08, +02.97, -14.80
      dd -04.02, +03.05, -14.30, -04.04, +03.03, -14.80
      dd -04.10, +03.05, -14.45, -04.08, +03.03, -14.80
      yrectl -04.04, +02.97, -14.80, -04.08, +03.03, -14.80
      ;yrectl -04.43, +02.90, -14.25, -04.43, +03.10, -14.50 ; Inner
      ;dd -04.43, +02.95, -14.30, -04.73, +02.95, -14.30
      ;dd -04.43, +02.95, -14.45, -04.65, +02.95, -14.45
      ;dd -04.43, +03.05, -14.30, -04.73, +03.05, -14.30
      ;dd -04.43, +03.05, -14.45, -04.65, +03.05, -14.45
      ;dd -04.73, +02.95, -14.30, -04.71, +02.97, -14.80
      ;dd -04.65, +02.95, -14.45, -04.67, +02.97, -14.80
      ;dd -04.73, +03.05, -14.30, -04.71, +03.03, -14.80
      ;dd -04.65, +03.05, -14.45, -04.67, +03.03, -14.80
      ;yrectl -04.71, +02.97, -14.80, -04.67, +03.03, -14.80
     ; Hinge
     r_5.lines.vertices.end:
    r_6.lines.vertices: ; Room 5
     ; Doorframe
      dd +03.00, +00.05, -16.85, +03.00, +06.00, -16.85
      dd +03.00, +06.00, -16.85, +03.00, +06.00, -14.15
      dd +03.00, +06.00, -14.15, +03.00, +00.05, -14.15
      dd +03.00, +00.05, -16.85, +03.30, +00.05, -16.85
      dd +03.30, +00.05, -16.85, +03.30, +00.05, -17.00
      dd +03.30, +00.05, -17.00, +03.45, +00.05, -17.00
      dd +03.45, +00.05, -17.00, +03.45, +00.05, -14.00
      dd +03.45, +00.05, -14.00, +03.30, +00.05, -14.00
      dd +03.30, +00.05, -14.00, +03.30, +00.05, -14.15
      dd +03.30, +00.05, -14.15, +03.00, +00.05, -14.15
      dd +03.00, +06.00, -16.85, +03.30, +06.00, -16.85
      dd +03.30, +06.00, -16.85, +03.30, +06.00, -17.00
      dd +03.30, +06.00, -17.00, +03.45, +06.00, -17.00
      dd +03.45, +06.00, -17.00, +03.45, +06.00, -14.00
      dd +03.45, +06.00, -14.00, +03.30, +06.00, -14.00
      dd +03.30, +06.00, -14.00, +03.30, +06.00, -14.15
      dd +03.30, +06.00, -14.15, +03.00, +06.00, -14.15
      dd +03.30, +00.05, -16.85, +03.30, +06.00, -16.85
      dd +03.30, +00.05, -17.00, +03.30, +06.00, -17.00
      dd +03.45, +00.05, -17.00, +03.45, +06.00, -17.00
      dd +03.45, +00.05, -14.00, +03.45, +06.00, -14.00
      dd +03.30, +00.05, -14.00, +03.30, +06.00, -14.00
      dd +03.30, +00.05, -14.15, +03.30, +06.00, -14.15
     ; Door
      rprisml +03.32, +00.07, -16.98, +03.43, +05.98, -14.02
      yrectl +03.32, +00.50, -14.50, +03.32, +02.75, -15.25 ; Door pattern (outer)
      yrectl +03.32, +00.50, -16.50, +03.32, +02.75, -15.75
      yrectl +03.32, +03.25, -14.50, +03.32, +05.50, -15.25
      yrectl +03.32, +03.25, -16.50, +03.32, +05.50, -15.75
      yrectl +03.35, +00.55, -14.55, +03.35, +02.70, -15.20
      yrectl +03.35, +00.55, -16.45, +03.35, +02.70, -15.80
      yrectl +03.35, +03.30, -14.55, +03.35, +05.45, -15.20
      yrectl +03.35, +03.30, -16.45, +03.35, +05.45, -15.80
      yrectl +03.35, +00.65, -14.65, +03.35, +02.60, -15.10
      yrectl +03.35, +00.65, -16.35, +03.35, +02.60, -15.90
      yrectl +03.35, +03.40, -14.65, +03.35, +05.35, -15.10
      yrectl +03.35, +03.40, -16.35, +03.35, +05.35, -15.90
      yrectl +03.32, +00.70, -14.70, +03.32, +02.55, -15.05
      yrectl +03.32, +00.70, -16.30, +03.32, +02.55, -15.95
      yrectl +03.32, +03.45, -14.70, +03.32, +05.30, -15.05
      yrectl +03.32, +03.45, -16.30, +03.32, +05.30, -15.95
      ;yrectl +03.43, +00.50, -14.50, +03.43, +02.75, -15.25 ; Inner
      ;yrectl +03.43, +00.50, -16.50, +03.43, +02.75, -15.75
      ;yrectl +03.43, +03.25, -14.50, +03.43, +05.50, -15.25
      ;yrectl +03.43, +03.25, -16.50, +03.43, +05.50, -15.75
      ;yrectl +03.40, +00.55, -14.55, +03.40, +02.70, -15.20
      ;yrectl +03.40, +00.55, -16.45, +03.40, +02.70, -15.80
      ;yrectl +03.40, +03.30, -14.55, +03.40, +05.45, -15.20
      ;yrectl +03.40, +03.30, -16.45, +03.40, +05.45, -15.80
      ;yrectl +03.40, +00.65, -14.65, +03.40, +02.60, -15.10
      ;yrectl +03.40, +00.65, -16.35, +03.40, +02.60, -15.90
      ;yrectl +03.40, +03.40, -14.65, +03.40, +05.35, -15.10
      ;yrectl +03.40, +03.40, -16.35, +03.40, +05.35, -15.90
      ;yrectl +03.43, +00.70, -14.70, +03.43, +02.55, -15.05
      ;yrectl +03.43, +00.70, -16.30, +03.43, +02.55, -15.95
      ;yrectl +03.43, +03.45, -14.70, +03.43, +05.30, -15.05
      ;yrectl +03.43, +03.45, -16.30, +03.43, +05.30, -15.95
     ; Doorknob
      yrectl +03.32, +02.90, -14.25, +03.32, +03.10, -14.50 ; Outer
      dd +03.32, +02.95, -14.30, +03.02, +02.95, -14.30
      dd +03.32, +02.95, -14.45, +03.10, +02.95, -14.45
      dd +03.32, +03.05, -14.30, +03.02, +03.05, -14.30
      dd +03.32, +03.05, -14.45, +03.10, +03.05, -14.45
      dd +03.02, +02.95, -14.30, +03.04, +02.97, -14.80
      dd +03.10, +02.95, -14.45, +03.08, +02.97, -14.80
      dd +03.02, +03.05, -14.30, +03.04, +03.03, -14.80
      dd +03.10, +03.05, -14.45, +03.08, +03.03, -14.80
      yrectl +03.04, +02.97, -14.80, +03.08, +03.03, -14.80
      ;yrectl +03.43, +02.90, -14.25, +03.43, +03.10, -14.50 ; Inner
      ;dd +03.43, +02.95, -14.30, +03.73, +02.95, -14.30
      ;dd +03.43, +02.95, -14.45, +03.65, +02.95, -14.45
      ;dd +03.43, +03.05, -14.30, +03.73, +03.05, -14.30
      ;dd +03.43, +03.05, -14.45, +03.65, +03.05, -14.45
      ;dd +03.73, +02.95, -14.30, +03.71, +02.97, -14.80
      ;dd +03.65, +02.95, -14.45, +03.67, +02.97, -14.80
      ;dd +03.73, +03.05, -14.30, +03.71, +03.03, -14.80
      ;dd +03.65, +03.05, -14.45, +03.67, +03.03, -14.80
      ;yrectl +03.71, +02.97, -14.80, +03.67, +03.03, -14.80
     ; Hinge 
     r_6.lines.vertices.end:
    r_7.lines.vertices: ; Room 6
     ; Doorframe
      dd -04.00, +00.05, -16.85, -04.00, +06.00, -16.85
      dd -04.00, +06.00, -16.85, -04.00, +06.00, -14.15
      dd -04.00, +06.00, -14.15, -04.00, +00.05, -14.15
      dd -04.00, +00.05, -16.85, -04.30, +00.05, -16.85
      dd -04.30, +00.05, -16.85, -04.30, +00.05, -17.00
      dd -04.30, +00.05, -17.00, -04.45, +00.06, -17.00
      dd -04.45, +00.05, -17.00, -04.45, +00.05, -14.00
      dd -04.45, +00.05, -14.00, -04.30, +00.05, -14.00
      dd -04.30, +00.05, -14.00, -04.30, +00.05, -14.15
      dd -04.30, +00.05, -14.15, -04.00, +00.05, -14.15
      dd -04.00, +06.00, -16.85, -04.30, +06.00, -16.85
      dd -04.30, +06.00, -16.85, -04.30, +06.00, -17.00
      dd -04.30, +06.00, -17.00, -04.45, +06.00, -17.00
      dd -04.45, +06.00, -17.00, -04.45, +06.00, -14.00
      dd -04.45, +06.00, -14.00, -04.30, +06.00, -14.00
      dd -04.30, +06.00, -14.00, -04.30, +06.00, -14.15
      dd -04.30, +06.00, -14.15, -04.00, +06.00, -14.15
      dd -04.30, +00.05, -16.85, -04.30, +06.00, -16.85
      dd -04.30, +00.05, -17.00, -04.30, +06.00, -17.00
      dd -04.45, +00.05, -17.00, -04.45, +06.00, -17.00
      dd -04.45, +00.05, -14.00, -04.45, +06.00, -14.00
      dd -04.30, +00.05, -14.00, -04.30, +06.00, -14.00
      dd -04.30, +00.05, -14.15, -04.30, +06.00, -14.15
     ; Door
      rprisml -04.32, +00.07, -16.98, -04.43, +05.98, -14.02
      yrectl -04.32, +00.50, -14.50, -04.32, +02.75, -15.25 ; Door pattern (outer)
      yrectl -04.32, +00.50, -16.50, -04.32, +02.75, -15.75
      yrectl -04.32, +03.25, -14.50, -04.32, +05.50, -15.25
      yrectl -04.32, +03.25, -16.50, -04.32, +05.50, -15.75
      yrectl -04.35, +00.55, -14.55, -04.35, +02.70, -15.20
      yrectl -04.35, +00.55, -16.45, -04.35, +02.70, -15.80
      yrectl -04.35, +03.30, -14.55, -04.35, +05.45, -15.20
      yrectl -04.35, +03.30, -16.45, -04.35, +05.45, -15.80
      yrectl -04.35, +00.65, -14.65, -04.35, +02.60, -15.10
      yrectl -04.35, +00.65, -16.35, -04.35, +02.60, -15.90
      yrectl -04.35, +03.40, -14.65, -04.35, +05.35, -15.10
      yrectl -04.35, +03.40, -16.35, -04.35, +05.35, -15.90
      yrectl -04.32, +00.70, -14.70, -04.32, +02.55, -15.05
      yrectl -04.32, +00.70, -16.30, -04.32, +02.55, -15.95
      yrectl -04.32, +03.45, -14.70, -04.32, +05.30, -15.05
      yrectl -04.32, +03.45, -16.30, -04.32, +05.30, -15.95
      ;yrectl -04.41, +00.50, -14.50, -04.41, +02.75, -15.25 ; Inner
      ;yrectl -04.41, +00.50, -16.50, -04.41, +02.75, -15.75
      ;yrectl -04.41, +03.25, -14.50, -04.41, +05.50, -15.25
      ;yrectl -04.41, +03.25, -16.50, -04.41, +05.50, -15.75
      ;yrectl -04.43, +00.55, -14.55, -04.43, +02.70, -15.20
      ;yrectl -04.43, +00.55, -16.45, -04.43, +02.70, -15.80
      ;yrectl -04.43, +03.30, -14.55, -04.43, +05.45, -15.20
      ;yrectl -04.43, +03.30, -16.45, -04.43, +05.45, -15.80
      ;yrectl -04.43, +00.65, -14.65, -04.43, +02.60, -15.10
      ;yrectl -04.43, +00.65, -16.35, -04.43, +02.60, -15.90
      ;yrectl -04.43, +03.40, -14.65, -04.43, +05.35, -15.10
      ;yrectl -04.43, +03.40, -16.35, -04.43, +05.35, -15.90
      ;yrectl -04.41, +00.70, -14.70, -04.41, +02.55, -15.05
      ;yrectl -04.41, +00.70, -16.30, -04.41, +02.55, -15.95
      ;yrectl -04.41, +03.45, -14.70, -04.41, +05.30, -15.05
      ;yrectl -04.41, +03.45, -16.30, -04.41, +05.30, -15.95
     ; Doorknob
      yrectl -04.32, +02.90, -14.25, -04.32, +03.10, -14.50 ; Outer
      dd -04.32, +02.95, -14.30, -04.02, +02.95, -14.30
      dd -04.32, +02.95, -14.45, -04.10, +02.95, -14.45
      dd -04.32, +03.05, -14.30, -04.02, +03.05, -14.30
      dd -04.32, +03.05, -14.45, -04.10, +03.05, -14.45
      dd -04.02, +02.95, -14.30, -04.04, +02.97, -14.80
      dd -04.10, +02.95, -14.45, -04.08, +02.97, -14.80
      dd -04.02, +03.05, -14.30, -04.04, +03.03, -14.80
      dd -04.10, +03.05, -14.45, -04.08, +03.03, -14.80
      yrectl -04.04, +02.97, -14.80, -04.08, +03.03, -14.80
      ;yrectl -04.43, +02.90, -14.25, -04.43, +03.10, -14.50 ; Inner
      ;dd -04.43, +02.95, -14.30, -04.73, +02.95, -14.30
      ;dd -04.43, +02.95, -14.45, -04.65, +02.95, -14.45
      ;dd -04.43, +03.05, -14.30, -04.73, +03.05, -14.30
      ;dd -04.43, +03.05, -14.45, -04.65, +03.05, -14.45
      ;dd -04.73, +02.95, -14.30, -04.71, +02.97, -14.80
      ;dd -04.65, +02.95, -14.45, -04.67, +02.97, -14.80
      ;dd -04.73, +03.05, -14.30, -04.71, +03.03, -14.80
      ;dd -04.65, +03.05, -14.45, -04.67, +03.03, -14.80
      ;yrectl -04.71, +02.97, -14.80, -04.67, +03.03, -14.80
     ; Hinge
     r_7.lines.vertices.end:
    r_8.lines.vertices: ; Room 7
     ; Doorframe
      dd +03.00, +00.05, -16.85, +03.00, +06.00, -16.85
      dd +03.00, +06.00, -16.85, +03.00, +06.00, -14.15
      dd +03.00, +06.00, -14.15, +03.00, +00.05, -14.15
      dd +03.00, +00.05, -16.85, +03.30, +00.05, -16.85
      dd +03.30, +00.05, -16.85, +03.30, +00.05, -17.00
      dd +03.30, +00.05, -17.00, +03.45, +00.05, -17.00
      dd +03.45, +00.05, -17.00, +03.45, +00.05, -14.00
      dd +03.45, +00.05, -14.00, +03.30, +00.05, -14.00
      dd +03.30, +00.05, -14.00, +03.30, +00.05, -14.15
      dd +03.30, +00.05, -14.15, +03.00, +00.05, -14.15
      dd +03.00, +06.00, -16.85, +03.30, +06.00, -16.85
      dd +03.30, +06.00, -16.85, +03.30, +06.00, -17.00
      dd +03.30, +06.00, -17.00, +03.45, +06.00, -17.00
      dd +03.45, +06.00, -17.00, +03.45, +06.00, -14.00
      dd +03.45, +06.00, -14.00, +03.30, +06.00, -14.00
      dd +03.30, +06.00, -14.00, +03.30, +06.00, -14.15
      dd +03.30, +06.00, -14.15, +03.00, +06.00, -14.15
      dd +03.30, +00.05, -16.85, +03.30, +06.00, -16.85
      dd +03.30, +00.05, -17.00, +03.30, +06.00, -17.00
      dd +03.45, +00.05, -17.00, +03.45, +06.00, -17.00
      dd +03.45, +00.05, -14.00, +03.45, +06.00, -14.00
      dd +03.30, +00.05, -14.00, +03.30, +06.00, -14.00
      dd +03.30, +00.05, -14.15, +03.30, +06.00, -14.15
     ; Door
      rprisml +03.32, +00.07, -16.98, +03.43, +05.98, -14.02
      yrectl +03.32, +00.50, -14.50, +03.32, +02.75, -15.25 ; Door pattern (outer)
      yrectl +03.32, +00.50, -16.50, +03.32, +02.75, -15.75
      yrectl +03.32, +03.25, -14.50, +03.32, +05.50, -15.25
      yrectl +03.32, +03.25, -16.50, +03.32, +05.50, -15.75
      yrectl +03.35, +00.55, -14.55, +03.35, +02.70, -15.20
      yrectl +03.35, +00.55, -16.45, +03.35, +02.70, -15.80
      yrectl +03.35, +03.30, -14.55, +03.35, +05.45, -15.20
      yrectl +03.35, +03.30, -16.45, +03.35, +05.45, -15.80
      yrectl +03.35, +00.65, -14.65, +03.35, +02.60, -15.10
      yrectl +03.35, +00.65, -16.35, +03.35, +02.60, -15.90
      yrectl +03.35, +03.40, -14.65, +03.35, +05.35, -15.10
      yrectl +03.35, +03.40, -16.35, +03.35, +05.35, -15.90
      yrectl +03.32, +00.70, -14.70, +03.32, +02.55, -15.05
      yrectl +03.32, +00.70, -16.30, +03.32, +02.55, -15.95
      yrectl +03.32, +03.45, -14.70, +03.32, +05.30, -15.05
      yrectl +03.32, +03.45, -16.30, +03.32, +05.30, -15.95
      ;yrectl +03.43, +00.50, -14.50, +03.43, +02.75, -15.25 ; Inner
      ;yrectl +03.43, +00.50, -16.50, +03.43, +02.75, -15.75
      ;yrectl +03.43, +03.25, -14.50, +03.43, +05.50, -15.25
      ;yrectl +03.43, +03.25, -16.50, +03.43, +05.50, -15.75
      ;yrectl +03.40, +00.55, -14.55, +03.40, +02.70, -15.20
      ;yrectl +03.40, +00.55, -16.45, +03.40, +02.70, -15.80
      ;yrectl +03.40, +03.30, -14.55, +03.40, +05.45, -15.20
      ;yrectl +03.40, +03.30, -16.45, +03.40, +05.45, -15.80
      ;yrectl +03.40, +00.65, -14.65, +03.40, +02.60, -15.10
      ;yrectl +03.40, +00.65, -16.35, +03.40, +02.60, -15.90
      ;yrectl +03.40, +03.40, -14.65, +03.40, +05.35, -15.10
      ;yrectl +03.40, +03.40, -16.35, +03.40, +05.35, -15.90
      ;yrectl +03.43, +00.70, -14.70, +03.43, +02.55, -15.05
      ;yrectl +03.43, +00.70, -16.30, +03.43, +02.55, -15.95
      ;yrectl +03.43, +03.45, -14.70, +03.43, +05.30, -15.05
      ;yrectl +03.43, +03.45, -16.30, +03.43, +05.30, -15.95
     ; Doorknob
      yrectl +03.32, +02.90, -14.25, +03.32, +03.10, -14.50 ; Outer
      dd +03.32, +02.95, -14.30, +03.02, +02.95, -14.30
      dd +03.32, +02.95, -14.45, +03.10, +02.95, -14.45
      dd +03.32, +03.05, -14.30, +03.02, +03.05, -14.30
      dd +03.32, +03.05, -14.45, +03.10, +03.05, -14.45
      dd +03.02, +02.95, -14.30, +03.04, +02.97, -14.80
      dd +03.10, +02.95, -14.45, +03.08, +02.97, -14.80
      dd +03.02, +03.05, -14.30, +03.04, +03.03, -14.80
      dd +03.10, +03.05, -14.45, +03.08, +03.03, -14.80
      yrectl +03.04, +02.97, -14.80, +03.08, +03.03, -14.80
      ;yrectl +03.43, +02.90, -14.25, +03.43, +03.10, -14.50 ; Inner
      ;dd +03.43, +02.95, -14.30, +03.73, +02.95, -14.30
      ;dd +03.43, +02.95, -14.45, +03.65, +02.95, -14.45
      ;dd +03.43, +03.05, -14.30, +03.73, +03.05, -14.30
      ;dd +03.43, +03.05, -14.45, +03.65, +03.05, -14.45
      ;dd +03.73, +02.95, -14.30, +03.71, +02.97, -14.80
      ;dd +03.65, +02.95, -14.45, +03.67, +02.97, -14.80
      ;dd +03.73, +03.05, -14.30, +03.71, +03.03, -14.80
      ;dd +03.65, +03.05, -14.45, +03.67, +03.03, -14.80
      ;yrectl +03.71, +02.97, -14.80, +03.67, +03.03, -14.80
     ; Hinge 
     r_8.lines.vertices.end:
    r_9.lines.vertices: ; Room 8
     ; Doorframe
      dd -04.00, +00.05, -16.85, -04.00, +06.00, -16.85
      dd -04.00, +06.00, -16.85, -04.00, +06.00, -14.15
      dd -04.00, +06.00, -14.15, -04.00, +00.05, -14.15
      dd -04.00, +00.05, -16.85, -04.30, +00.05, -16.85
      dd -04.30, +00.05, -16.85, -04.30, +00.05, -17.00
      dd -04.30, +00.05, -17.00, -04.45, +00.06, -17.00
      dd -04.45, +00.05, -17.00, -04.45, +00.05, -14.00
      dd -04.45, +00.05, -14.00, -04.30, +00.05, -14.00
      dd -04.30, +00.05, -14.00, -04.30, +00.05, -14.15
      dd -04.30, +00.05, -14.15, -04.00, +00.05, -14.15
      dd -04.00, +06.00, -16.85, -04.30, +06.00, -16.85
      dd -04.30, +06.00, -16.85, -04.30, +06.00, -17.00
      dd -04.30, +06.00, -17.00, -04.45, +06.00, -17.00
      dd -04.45, +06.00, -17.00, -04.45, +06.00, -14.00
      dd -04.45, +06.00, -14.00, -04.30, +06.00, -14.00
      dd -04.30, +06.00, -14.00, -04.30, +06.00, -14.15
      dd -04.30, +06.00, -14.15, -04.00, +06.00, -14.15
      dd -04.30, +00.05, -16.85, -04.30, +06.00, -16.85
      dd -04.30, +00.05, -17.00, -04.30, +06.00, -17.00
      dd -04.45, +00.05, -17.00, -04.45, +06.00, -17.00
      dd -04.45, +00.05, -14.00, -04.45, +06.00, -14.00
      dd -04.30, +00.05, -14.00, -04.30, +06.00, -14.00
      dd -04.30, +00.05, -14.15, -04.30, +06.00, -14.15
     ; Door
      rprisml -04.32, +00.07, -16.98, -04.43, +05.98, -14.02
      yrectl -04.32, +00.50, -14.50, -04.32, +02.75, -15.25 ; Door pattern (outer)
      yrectl -04.32, +00.50, -16.50, -04.32, +02.75, -15.75
      yrectl -04.32, +03.25, -14.50, -04.32, +05.50, -15.25
      yrectl -04.32, +03.25, -16.50, -04.32, +05.50, -15.75
      yrectl -04.35, +00.55, -14.55, -04.35, +02.70, -15.20
      yrectl -04.35, +00.55, -16.45, -04.35, +02.70, -15.80
      yrectl -04.35, +03.30, -14.55, -04.35, +05.45, -15.20
      yrectl -04.35, +03.30, -16.45, -04.35, +05.45, -15.80
      yrectl -04.35, +00.65, -14.65, -04.35, +02.60, -15.10
      yrectl -04.35, +00.65, -16.35, -04.35, +02.60, -15.90
      yrectl -04.35, +03.40, -14.65, -04.35, +05.35, -15.10
      yrectl -04.35, +03.40, -16.35, -04.35, +05.35, -15.90
      yrectl -04.32, +00.70, -14.70, -04.32, +02.55, -15.05
      yrectl -04.32, +00.70, -16.30, -04.32, +02.55, -15.95
      yrectl -04.32, +03.45, -14.70, -04.32, +05.30, -15.05
      yrectl -04.32, +03.45, -16.30, -04.32, +05.30, -15.95
      ;yrectl -04.41, +00.50, -14.50, -04.41, +02.75, -15.25 ; Inner
      ;yrectl -04.41, +00.50, -16.50, -04.41, +02.75, -15.75
      ;yrectl -04.41, +03.25, -14.50, -04.41, +05.50, -15.25
      ;yrectl -04.41, +03.25, -16.50, -04.41, +05.50, -15.75
      ;yrectl -04.43, +00.55, -14.55, -04.43, +02.70, -15.20
      ;yrectl -04.43, +00.55, -16.45, -04.43, +02.70, -15.80
      ;yrectl -04.43, +03.30, -14.55, -04.43, +05.45, -15.20
      ;yrectl -04.43, +03.30, -16.45, -04.43, +05.45, -15.80
      ;yrectl -04.43, +00.65, -14.65, -04.43, +02.60, -15.10
      ;yrectl -04.43, +00.65, -16.35, -04.43, +02.60, -15.90
      ;yrectl -04.43, +03.40, -14.65, -04.43, +05.35, -15.10
      ;yrectl -04.43, +03.40, -16.35, -04.43, +05.35, -15.90
      ;yrectl -04.41, +00.70, -14.70, -04.41, +02.55, -15.05
      ;yrectl -04.41, +00.70, -16.30, -04.41, +02.55, -15.95
      ;yrectl -04.41, +03.45, -14.70, -04.41, +05.30, -15.05
      ;yrectl -04.41, +03.45, -16.30, -04.41, +05.30, -15.95
     ; Doorknob
      yrectl -04.32, +02.90, -14.25, -04.32, +03.10, -14.50 ; Outer
      dd -04.32, +02.95, -14.30, -04.02, +02.95, -14.30
      dd -04.32, +02.95, -14.45, -04.10, +02.95, -14.45
      dd -04.32, +03.05, -14.30, -04.02, +03.05, -14.30
      dd -04.32, +03.05, -14.45, -04.10, +03.05, -14.45
      dd -04.02, +02.95, -14.30, -04.04, +02.97, -14.80
      dd -04.10, +02.95, -14.45, -04.08, +02.97, -14.80
      dd -04.02, +03.05, -14.30, -04.04, +03.03, -14.80
      dd -04.10, +03.05, -14.45, -04.08, +03.03, -14.80
      yrectl -04.04, +02.97, -14.80, -04.08, +03.03, -14.80
      ;yrectl -04.43, +02.90, -14.25, -04.43, +03.10, -14.50 ; Inner
      ;dd -04.43, +02.95, -14.30, -04.73, +02.95, -14.30
      ;dd -04.43, +02.95, -14.45, -04.65, +02.95, -14.45
      ;dd -04.43, +03.05, -14.30, -04.73, +03.05, -14.30
      ;dd -04.43, +03.05, -14.45, -04.65, +03.05, -14.45
      ;dd -04.73, +02.95, -14.30, -04.71, +02.97, -14.80
      ;dd -04.65, +02.95, -14.45, -04.67, +02.97, -14.80
      ;dd -04.73, +03.05, -14.30, -04.71, +03.03, -14.80
      ;dd -04.65, +03.05, -14.45, -04.67, +03.03, -14.80
      ;yrectl -04.71, +02.97, -14.80, -04.67, +03.03, -14.80
     ; Hinge
     r_9.lines.vertices.end:
    r_10.lines.vertices: ; Room 9
     ; Doorframe
      dd +03.00, +00.05, -16.85, +03.00, +06.00, -16.85
      dd +03.00, +06.00, -16.85, +03.00, +06.00, -14.15
      dd +03.00, +06.00, -14.15, +03.00, +00.05, -14.15
      dd +03.00, +00.05, -16.85, +03.30, +00.05, -16.85
      dd +03.30, +00.05, -16.85, +03.30, +00.05, -17.00
      dd +03.30, +00.05, -17.00, +03.45, +00.05, -17.00
      dd +03.45, +00.05, -17.00, +03.45, +00.05, -14.00
      dd +03.45, +00.05, -14.00, +03.30, +00.05, -14.00
      dd +03.30, +00.05, -14.00, +03.30, +00.05, -14.15
      dd +03.30, +00.05, -14.15, +03.00, +00.05, -14.15
      dd +03.00, +06.00, -16.85, +03.30, +06.00, -16.85
      dd +03.30, +06.00, -16.85, +03.30, +06.00, -17.00
      dd +03.30, +06.00, -17.00, +03.45, +06.00, -17.00
      dd +03.45, +06.00, -17.00, +03.45, +06.00, -14.00
      dd +03.45, +06.00, -14.00, +03.30, +06.00, -14.00
      dd +03.30, +06.00, -14.00, +03.30, +06.00, -14.15
      dd +03.30, +06.00, -14.15, +03.00, +06.00, -14.15
      dd +03.30, +00.05, -16.85, +03.30, +06.00, -16.85
      dd +03.30, +00.05, -17.00, +03.30, +06.00, -17.00
      dd +03.45, +00.05, -17.00, +03.45, +06.00, -17.00
      dd +03.45, +00.05, -14.00, +03.45, +06.00, -14.00
      dd +03.30, +00.05, -14.00, +03.30, +06.00, -14.00
      dd +03.30, +00.05, -14.15, +03.30, +06.00, -14.15
     ; Door
      rprisml +03.32, +00.07, -16.98, +03.43, +05.98, -14.02
      yrectl +03.32, +00.50, -14.50, +03.32, +02.75, -15.25 ; Door pattern (outer)
      yrectl +03.32, +00.50, -16.50, +03.32, +02.75, -15.75
      yrectl +03.32, +03.25, -14.50, +03.32, +05.50, -15.25
      yrectl +03.32, +03.25, -16.50, +03.32, +05.50, -15.75
      yrectl +03.35, +00.55, -14.55, +03.35, +02.70, -15.20
      yrectl +03.35, +00.55, -16.45, +03.35, +02.70, -15.80
      yrectl +03.35, +03.30, -14.55, +03.35, +05.45, -15.20
      yrectl +03.35, +03.30, -16.45, +03.35, +05.45, -15.80
      yrectl +03.35, +00.65, -14.65, +03.35, +02.60, -15.10
      yrectl +03.35, +00.65, -16.35, +03.35, +02.60, -15.90
      yrectl +03.35, +03.40, -14.65, +03.35, +05.35, -15.10
      yrectl +03.35, +03.40, -16.35, +03.35, +05.35, -15.90
      yrectl +03.32, +00.70, -14.70, +03.32, +02.55, -15.05
      yrectl +03.32, +00.70, -16.30, +03.32, +02.55, -15.95
      yrectl +03.32, +03.45, -14.70, +03.32, +05.30, -15.05
      yrectl +03.32, +03.45, -16.30, +03.32, +05.30, -15.95
      ;yrectl +03.43, +00.50, -14.50, +03.43, +02.75, -15.25 ; Inner
      ;yrectl +03.43, +00.50, -16.50, +03.43, +02.75, -15.75
      ;yrectl +03.43, +03.25, -14.50, +03.43, +05.50, -15.25
      ;yrectl +03.43, +03.25, -16.50, +03.43, +05.50, -15.75
      ;yrectl +03.40, +00.55, -14.55, +03.40, +02.70, -15.20
      ;yrectl +03.40, +00.55, -16.45, +03.40, +02.70, -15.80
      ;yrectl +03.40, +03.30, -14.55, +03.40, +05.45, -15.20
      ;yrectl +03.40, +03.30, -16.45, +03.40, +05.45, -15.80
      ;yrectl +03.40, +00.65, -14.65, +03.40, +02.60, -15.10
      ;yrectl +03.40, +00.65, -16.35, +03.40, +02.60, -15.90
      ;yrectl +03.40, +03.40, -14.65, +03.40, +05.35, -15.10
      ;yrectl +03.40, +03.40, -16.35, +03.40, +05.35, -15.90
      ;yrectl +03.43, +00.70, -14.70, +03.43, +02.55, -15.05
      ;yrectl +03.43, +00.70, -16.30, +03.43, +02.55, -15.95
      ;yrectl +03.43, +03.45, -14.70, +03.43, +05.30, -15.05
      ;yrectl +03.43, +03.45, -16.30, +03.43, +05.30, -15.95
     ; Doorknob
      yrectl +03.32, +02.90, -14.25, +03.32, +03.10, -14.50 ; Outer
      dd +03.32, +02.95, -14.30, +03.02, +02.95, -14.30
      dd +03.32, +02.95, -14.45, +03.10, +02.95, -14.45
      dd +03.32, +03.05, -14.30, +03.02, +03.05, -14.30
      dd +03.32, +03.05, -14.45, +03.10, +03.05, -14.45
      dd +03.02, +02.95, -14.30, +03.04, +02.97, -14.80
      dd +03.10, +02.95, -14.45, +03.08, +02.97, -14.80
      dd +03.02, +03.05, -14.30, +03.04, +03.03, -14.80
      dd +03.10, +03.05, -14.45, +03.08, +03.03, -14.80
      yrectl +03.04, +02.97, -14.80, +03.08, +03.03, -14.80
      ;yrectl +03.43, +02.90, -14.25, +03.43, +03.10, -14.50 ; Inner
      ;dd +03.43, +02.95, -14.30, +03.73, +02.95, -14.30
      ;dd +03.43, +02.95, -14.45, +03.65, +02.95, -14.45
      ;dd +03.43, +03.05, -14.30, +03.73, +03.05, -14.30
      ;dd +03.43, +03.05, -14.45, +03.65, +03.05, -14.45
      ;dd +03.73, +02.95, -14.30, +03.71, +02.97, -14.80
      ;dd +03.65, +02.95, -14.45, +03.67, +02.97, -14.80
      ;dd +03.73, +03.05, -14.30, +03.71, +03.03, -14.80
      ;dd +03.65, +03.05, -14.45, +03.67, +03.03, -14.80
      ;yrectl +03.71, +02.97, -14.80, +03.67, +03.03, -14.80
     ; Hinge 
     r_10.lines.vertices.end:
    r_11.lines.vertices: ; Room 10
     ; Doorframe
      dd -04.00, +00.05, -16.85, -04.00, +06.00, -16.85
      dd -04.00, +06.00, -16.85, -04.00, +06.00, -14.15
      dd -04.00, +06.00, -14.15, -04.00, +00.05, -14.15
      dd -04.00, +00.05, -16.85, -04.30, +00.05, -16.85
      dd -04.30, +00.05, -16.85, -04.30, +00.05, -17.00
      dd -04.30, +00.05, -17.00, -04.45, +00.06, -17.00
      dd -04.45, +00.05, -17.00, -04.45, +00.05, -14.00
      dd -04.45, +00.05, -14.00, -04.30, +00.05, -14.00
      dd -04.30, +00.05, -14.00, -04.30, +00.05, -14.15
      dd -04.30, +00.05, -14.15, -04.00, +00.05, -14.15
      dd -04.00, +06.00, -16.85, -04.30, +06.00, -16.85
      dd -04.30, +06.00, -16.85, -04.30, +06.00, -17.00
      dd -04.30, +06.00, -17.00, -04.45, +06.00, -17.00
      dd -04.45, +06.00, -17.00, -04.45, +06.00, -14.00
      dd -04.45, +06.00, -14.00, -04.30, +06.00, -14.00
      dd -04.30, +06.00, -14.00, -04.30, +06.00, -14.15
      dd -04.30, +06.00, -14.15, -04.00, +06.00, -14.15
      dd -04.30, +00.05, -16.85, -04.30, +06.00, -16.85
      dd -04.30, +00.05, -17.00, -04.30, +06.00, -17.00
      dd -04.45, +00.05, -17.00, -04.45, +06.00, -17.00
      dd -04.45, +00.05, -14.00, -04.45, +06.00, -14.00
      dd -04.30, +00.05, -14.00, -04.30, +06.00, -14.00
      dd -04.30, +00.05, -14.15, -04.30, +06.00, -14.15
     ; Door
      rprisml -04.32, +00.07, -16.98, -04.43, +05.98, -14.02
      yrectl -04.32, +00.50, -14.50, -04.32, +02.75, -15.25 ; Door pattern (outer)
      yrectl -04.32, +00.50, -16.50, -04.32, +02.75, -15.75
      yrectl -04.32, +03.25, -14.50, -04.32, +05.50, -15.25
      yrectl -04.32, +03.25, -16.50, -04.32, +05.50, -15.75
      yrectl -04.35, +00.55, -14.55, -04.35, +02.70, -15.20
      yrectl -04.35, +00.55, -16.45, -04.35, +02.70, -15.80
      yrectl -04.35, +03.30, -14.55, -04.35, +05.45, -15.20
      yrectl -04.35, +03.30, -16.45, -04.35, +05.45, -15.80
      yrectl -04.35, +00.65, -14.65, -04.35, +02.60, -15.10
      yrectl -04.35, +00.65, -16.35, -04.35, +02.60, -15.90
      yrectl -04.35, +03.40, -14.65, -04.35, +05.35, -15.10
      yrectl -04.35, +03.40, -16.35, -04.35, +05.35, -15.90
      yrectl -04.32, +00.70, -14.70, -04.32, +02.55, -15.05
      yrectl -04.32, +00.70, -16.30, -04.32, +02.55, -15.95
      yrectl -04.32, +03.45, -14.70, -04.32, +05.30, -15.05
      yrectl -04.32, +03.45, -16.30, -04.32, +05.30, -15.95
      ;yrectl -04.41, +00.50, -14.50, -04.41, +02.75, -15.25 ; Inner
      ;yrectl -04.41, +00.50, -16.50, -04.41, +02.75, -15.75
      ;yrectl -04.41, +03.25, -14.50, -04.41, +05.50, -15.25
      ;yrectl -04.41, +03.25, -16.50, -04.41, +05.50, -15.75
      ;yrectl -04.43, +00.55, -14.55, -04.43, +02.70, -15.20
      ;yrectl -04.43, +00.55, -16.45, -04.43, +02.70, -15.80
      ;yrectl -04.43, +03.30, -14.55, -04.43, +05.45, -15.20
      ;yrectl -04.43, +03.30, -16.45, -04.43, +05.45, -15.80
      ;yrectl -04.43, +00.65, -14.65, -04.43, +02.60, -15.10
      ;yrectl -04.43, +00.65, -16.35, -04.43, +02.60, -15.90
      ;yrectl -04.43, +03.40, -14.65, -04.43, +05.35, -15.10
      ;yrectl -04.43, +03.40, -16.35, -04.43, +05.35, -15.90
      ;yrectl -04.41, +00.70, -14.70, -04.41, +02.55, -15.05
      ;yrectl -04.41, +00.70, -16.30, -04.41, +02.55, -15.95
      ;yrectl -04.41, +03.45, -14.70, -04.41, +05.30, -15.05
      ;yrectl -04.41, +03.45, -16.30, -04.41, +05.30, -15.95
     ; Doorknob
      yrectl -04.32, +02.90, -14.25, -04.32, +03.10, -14.50 ; Outer
      dd -04.32, +02.95, -14.30, -04.02, +02.95, -14.30
      dd -04.32, +02.95, -14.45, -04.10, +02.95, -14.45
      dd -04.32, +03.05, -14.30, -04.02, +03.05, -14.30
      dd -04.32, +03.05, -14.45, -04.10, +03.05, -14.45
      dd -04.02, +02.95, -14.30, -04.04, +02.97, -14.80
      dd -04.10, +02.95, -14.45, -04.08, +02.97, -14.80
      dd -04.02, +03.05, -14.30, -04.04, +03.03, -14.80
      dd -04.10, +03.05, -14.45, -04.08, +03.03, -14.80
      yrectl -04.04, +02.97, -14.80, -04.08, +03.03, -14.80
      ;yrectl -04.43, +02.90, -14.25, -04.43, +03.10, -14.50 ; Inner
      ;dd -04.43, +02.95, -14.30, -04.73, +02.95, -14.30
      ;dd -04.43, +02.95, -14.45, -04.65, +02.95, -14.45
      ;dd -04.43, +03.05, -14.30, -04.73, +03.05, -14.30
      ;dd -04.43, +03.05, -14.45, -04.65, +03.05, -14.45
      ;dd -04.73, +02.95, -14.30, -04.71, +02.97, -14.80
      ;dd -04.65, +02.95, -14.45, -04.67, +02.97, -14.80
      ;dd -04.73, +03.05, -14.30, -04.71, +03.03, -14.80
      ;dd -04.65, +03.05, -14.45, -04.67, +03.03, -14.80
      ;yrectl -04.71, +02.97, -14.80, -04.67, +03.03, -14.80
     ; Hinge
     r_11.lines.vertices.end:
    r_12.lines.vertices: ; Room 11
     ; Doorframe
      dd +03.00, +00.05, -16.85, +03.00, +06.00, -16.85
      dd +03.00, +06.00, -16.85, +03.00, +06.00, -14.15
      dd +03.00, +06.00, -14.15, +03.00, +00.05, -14.15
      dd +03.00, +00.05, -16.85, +03.30, +00.05, -16.85
      dd +03.30, +00.05, -16.85, +03.30, +00.05, -17.00
      dd +03.30, +00.05, -17.00, +03.45, +00.05, -17.00
      dd +03.45, +00.05, -17.00, +03.45, +00.05, -14.00
      dd +03.45, +00.05, -14.00, +03.30, +00.05, -14.00
      dd +03.30, +00.05, -14.00, +03.30, +00.05, -14.15
      dd +03.30, +00.05, -14.15, +03.00, +00.05, -14.15
      dd +03.00, +06.00, -16.85, +03.30, +06.00, -16.85
      dd +03.30, +06.00, -16.85, +03.30, +06.00, -17.00
      dd +03.30, +06.00, -17.00, +03.45, +06.00, -17.00
      dd +03.45, +06.00, -17.00, +03.45, +06.00, -14.00
      dd +03.45, +06.00, -14.00, +03.30, +06.00, -14.00
      dd +03.30, +06.00, -14.00, +03.30, +06.00, -14.15
      dd +03.30, +06.00, -14.15, +03.00, +06.00, -14.15
      dd +03.30, +00.05, -16.85, +03.30, +06.00, -16.85
      dd +03.30, +00.05, -17.00, +03.30, +06.00, -17.00
      dd +03.45, +00.05, -17.00, +03.45, +06.00, -17.00
      dd +03.45, +00.05, -14.00, +03.45, +06.00, -14.00
      dd +03.30, +00.05, -14.00, +03.30, +06.00, -14.00
      dd +03.30, +00.05, -14.15, +03.30, +06.00, -14.15
     ; Door
      rprisml +03.32, +00.07, -16.98, +03.43, +05.98, -14.02
      yrectl +03.32, +00.50, -14.50, +03.32, +02.75, -15.25 ; Door pattern (outer)
      yrectl +03.32, +00.50, -16.50, +03.32, +02.75, -15.75
      yrectl +03.32, +03.25, -14.50, +03.32, +05.50, -15.25
      yrectl +03.32, +03.25, -16.50, +03.32, +05.50, -15.75
      yrectl +03.35, +00.55, -14.55, +03.35, +02.70, -15.20
      yrectl +03.35, +00.55, -16.45, +03.35, +02.70, -15.80
      yrectl +03.35, +03.30, -14.55, +03.35, +05.45, -15.20
      yrectl +03.35, +03.30, -16.45, +03.35, +05.45, -15.80
      yrectl +03.35, +00.65, -14.65, +03.35, +02.60, -15.10
      yrectl +03.35, +00.65, -16.35, +03.35, +02.60, -15.90
      yrectl +03.35, +03.40, -14.65, +03.35, +05.35, -15.10
      yrectl +03.35, +03.40, -16.35, +03.35, +05.35, -15.90
      yrectl +03.32, +00.70, -14.70, +03.32, +02.55, -15.05
      yrectl +03.32, +00.70, -16.30, +03.32, +02.55, -15.95
      yrectl +03.32, +03.45, -14.70, +03.32, +05.30, -15.05
      yrectl +03.32, +03.45, -16.30, +03.32, +05.30, -15.95
      ;yrectl +03.43, +00.50, -14.50, +03.43, +02.75, -15.25 ; Inner
      ;yrectl +03.43, +00.50, -16.50, +03.43, +02.75, -15.75
      ;yrectl +03.43, +03.25, -14.50, +03.43, +05.50, -15.25
      ;yrectl +03.43, +03.25, -16.50, +03.43, +05.50, -15.75
      ;yrectl +03.40, +00.55, -14.55, +03.40, +02.70, -15.20
      ;yrectl +03.40, +00.55, -16.45, +03.40, +02.70, -15.80
      ;yrectl +03.40, +03.30, -14.55, +03.40, +05.45, -15.20
      ;yrectl +03.40, +03.30, -16.45, +03.40, +05.45, -15.80
      ;yrectl +03.40, +00.65, -14.65, +03.40, +02.60, -15.10
      ;yrectl +03.40, +00.65, -16.35, +03.40, +02.60, -15.90
      ;yrectl +03.40, +03.40, -14.65, +03.40, +05.35, -15.10
      ;yrectl +03.40, +03.40, -16.35, +03.40, +05.35, -15.90
      ;yrectl +03.43, +00.70, -14.70, +03.43, +02.55, -15.05
      ;yrectl +03.43, +00.70, -16.30, +03.43, +02.55, -15.95
      ;yrectl +03.43, +03.45, -14.70, +03.43, +05.30, -15.05
      ;yrectl +03.43, +03.45, -16.30, +03.43, +05.30, -15.95
     ; Doorknob
      yrectl +03.32, +02.90, -14.25, +03.32, +03.10, -14.50 ; Outer
      dd +03.32, +02.95, -14.30, +03.02, +02.95, -14.30
      dd +03.32, +02.95, -14.45, +03.10, +02.95, -14.45
      dd +03.32, +03.05, -14.30, +03.02, +03.05, -14.30
      dd +03.32, +03.05, -14.45, +03.10, +03.05, -14.45
      dd +03.02, +02.95, -14.30, +03.04, +02.97, -14.80
      dd +03.10, +02.95, -14.45, +03.08, +02.97, -14.80
      dd +03.02, +03.05, -14.30, +03.04, +03.03, -14.80
      dd +03.10, +03.05, -14.45, +03.08, +03.03, -14.80
      yrectl +03.04, +02.97, -14.80, +03.08, +03.03, -14.80
      ;yrectl +03.43, +02.90, -14.25, +03.43, +03.10, -14.50 ; Inner
      ;dd +03.43, +02.95, -14.30, +03.73, +02.95, -14.30
      ;dd +03.43, +02.95, -14.45, +03.65, +02.95, -14.45
      ;dd +03.43, +03.05, -14.30, +03.73, +03.05, -14.30
      ;dd +03.43, +03.05, -14.45, +03.65, +03.05, -14.45
      ;dd +03.73, +02.95, -14.30, +03.71, +02.97, -14.80
      ;dd +03.65, +02.95, -14.45, +03.67, +02.97, -14.80
      ;dd +03.73, +03.05, -14.30, +03.71, +03.03, -14.80
      ;dd +03.65, +03.05, -14.45, +03.67, +03.03, -14.80
      ;yrectl +03.71, +02.97, -14.80, +03.67, +03.03, -14.80
     ; Hinge 
     r_12.lines.vertices.end:
    r_13.lines.vertices: ; Room 12
     ; Doorframe
      dd -01.85, +00.05, +70.00, -01.85, +06.00, +70.00
      dd -01.85, +06.00, +70.00, +00.85, +06.00, +70.00
      dd +00.85, +06.00, +70.00, +00.85, +00.05, +70.00
      dd -01.85, +00.05, +70.00, -01.85, +00.05, +70.30
      dd -01.85, +00.05, +70.30, -02.00, +00.05, +70.30
      dd -02.00, +00.05, +70.30, -02.00, +00.05, +70.45
      dd -02.00, +00.05, +70.45, +01.00, +00.05, +70.45
      dd +01.00, +00.05, +70.45, +01.00, +00.05, +70.30
      dd +01.00, +00.05, +70.30, +00.85, +00.05, +70.30
      dd +00.85, +00.05, +70.30, +00.85, +00.05, +70.00
      dd -01.85, +06.00, +70.00, -01.85, +06.00, +70.30
      dd -01.85, +06.00, +70.30, -02.00, +06.00, +70.30
      dd -02.00, +06.00, +70.30, -02.00, +06.00, +70.45
      dd -02.00, +06.00, +70.45, +01.00, +06.00, +70.45
      dd +01.00, +06.00, +70.45, +01.00, +06.00, +70.30
      dd +01.00, +06.00, +70.30, +00.85, +06.00, +70.30
      dd +00.85, +06.00, +70.30, +00.85, +06.00, +70.00
      dd -01.85, +00.05, +70.30, -01.85, +06.00, +70.30
      dd -02.00, +00.05, +70.30, -02.00, +06.00, +70.30
      dd -02.00, +00.05, +70.45, -02.00, +06.00, +70.45
      dd +01.00, +00.05, +70.45, +01.00, +06.00, +70.45
      dd +01.00, +00.05, +70.30, +01.00, +06.00, +70.30
      dd +00.85, +00.05, +70.30, +00.85, +06.00, +70.30
     ; Door
      rprisml -01.98, +00.07, +70.32, +00.98, +05.98, +70.43
      yrectl -01.50, +00.50, +70.32, -00.75, +02.75, +70.32 ; Door pattern (outer)
      yrectl +00.50, +00.50, +70.32, -00.25, +02.75, +70.32
      yrectl -01.50, +03.25, +70.32, -00.75, +05.50, +70.32
      yrectl +00.50, +03.25, +70.32, -00.25, +05.50, +70.32
      yrectl -01.45, +00.55, +70.35, -00.80, +02.70, +70.35
      yrectl +00.45, +00.55, +70.35, -00.20, +02.70, +70.35
      yrectl -01.45, +03.30, +70.35, -00.80, +05.45, +70.35
      yrectl +00.45, +03.30, +70.35, -00.20, +05.45, +70.35
      yrectl -01.35, +00.65, +70.35, -00.90, +02.60, +70.35
      yrectl +00.35, +00.65, +70.35, -00.10, +02.60, +70.35
      yrectl -01.35, +03.40, +70.35, -00.90, +05.35, +70.35
      yrectl +00.35, +03.40, +70.35, -00.10, +05.35, +70.35
      yrectl -01.30, +00.70, +70.32, -00.95, +02.55, +70.32
      yrectl +00.30, +00.70, +70.32, -00.05, +02.55, +70.32
      yrectl -01.30, +03.45, +70.32, -00.95, +05.30, +70.32
      yrectl +00.30, +03.45, +70.32, -00.05, +05.30, +70.32
      ;yrectl -01.50, +00.50, +70.40, -00.75, +02.75, +70.40 ; Inner
      ;yrectl +00.50, +00.50, +70.40, -00.25, +02.75, +70.40
      ;yrectl -01.50, +03.25, +70.40, -00.75, +05.50, +70.40
      ;yrectl +00.50, +03.25, +70.40, -00.25, +05.50, +70.40
      ;yrectl -01.45, +00.55, +70.43, -00.80, +02.70, +70.43
      ;yrectl +00.45, +00.55, +70.43, -00.20, +02.70, +70.43
      ;yrectl -01.45, +03.30, +70.43, -00.80, +05.45, +70.43
      ;yrectl +00.45, +03.30, +70.43, -00.20, +05.45, +70.43
      ;yrectl -01.35, +00.65, +70.43, -00.90, +02.60, +70.43
      ;yrectl +00.35, +00.65, +70.43, -00.10, +02.60, +70.43
      ;yrectl -01.35, +03.40, +70.43, -00.90, +05.35, +70.43
      ;yrectl +00.35, +03.40, +70.43, -00.10, +05.35, +70.43
      ;yrectl -01.30, +00.70, +70.40, -00.95, +02.55, +70.40
      ;yrectl +00.30, +00.70, +70.40, -00.05, +02.55, +70.40
      ;yrectl -01.30, +03.45, +70.40, -00.95, +05.30, +70.40
      ;yrectl +00.30, +03.45, +70.40, -00.05, +05.30, +70.40 
     ; Doorknob
      yrectl -01.75, +02.90, +70.32, -01.50, +03.10, +70.32 ; Outer
      dd -01.70, +02.95, +70.32, -01.70, +02.95, +70.02
      dd -01.70, +03.05, +70.32, -01.70, +03.05, +70.02
      dd -01.55, +02.95, +70.32, -01.55, +02.95, +70.10
      dd -01.55, +03.05, +70.32, -01.55, +03.05, +70.10
      dd -01.70, +02.95, +70.02, -01.20, +02.97, +70.04
      dd -01.70, +03.05, +70.02, -01.20, +03.03, +70.04
      dd -01.55, +02.95, +70.10, -01.20, +02.97, +70.08
      dd -01.55, +03.05, +70.10, -01.20, +03.03, +70.08
      yrectl -01.20, +02.97, +70.04, -01.20, +03.03, +70.08
      ;yrectl -01.75, +02.90, +70.43, -01.50, +03.10, +70.43 ; Inner
      ;dd -01.70, +02.95, +70.43, -01.70, +02.95, +70.81
      ;dd -01.70, +03.05, +70.43, -01.70, +03.05, +70.81
      ;dd -01.55, +02.95, +70.43, -01.55, +02.95, +70.73
      ;dd -01.55, +03.05, +70.43, -01.55, +03.05, +70.73
      ;dd -01.70, +02.95, +70.81, -01.20, +02.97, +70.79
      ;dd -01.70, +03.05, +70.81, -01.20, +03.03, +70.79
      ;dd -01.55, +02.95, +70.73, -01.20, +02.97, +70.75
      ;dd -01.55, +03.05, +70.73, -01.20, +03.03, +70.75
      ;yrectl -01.20, +02.97, +70.79, -01.20, +03.03, +70.75
     ; Hinge
     r_13.lines.vertices.end:
    lines.end:
   lines.elements:
    r_1.lines.elements:
     r_1.1e: counte (r_1.lines.vertices-lines)/4/3, (r_1.lines.vertices.end-lines)/4/3
     r_1.1e.end:
    r_2.lines.elements:
     r_2.1e: counte (r_2.lines.vertices-lines)/4/3, (r_2.lines.vertices.end-lines)/4/3
     r_2.1e.end:
    r_3.lines.elements:
     r_3.1e: counte (r_3.lines.vertices-lines)/4/3, (r_3.lines.vertices.end-lines)/4/3
     r_3.1e.end:
    r_4.lines.elements:
     r_4.1e: counte (r_4.lines.vertices-lines)/4/3, (r_4.lines.vertices.end-lines)/4/3
     r_4.1e.end:
    r_5.lines.elements:
     r_5.1e: counte (r_5.lines.vertices-lines)/4/3, (r_5.lines.vertices.end-lines)/4/3
     r_5.1e.end:
    r_6.lines.elements:
     r_6.1e: counte (r_6.lines.vertices-lines)/4/3, (r_6.lines.vertices.end-lines)/4/3
     r_6.1e.end:
    r_7.lines.elements:
     r_7.1e: counte (r_7.lines.vertices-lines)/4/3, (r_7.lines.vertices.end-lines)/4/3
     r_7.1e.end:
    r_8.lines.elements:
     r_8.1e: counte (r_8.lines.vertices-lines)/4/3, (r_8.lines.vertices.end-lines)/4/3
     r_8.1e.end:
    r_9.lines.elements:
     r_9.1e: counte (r_9.lines.vertices-lines)/4/3, (r_9.lines.vertices.end-lines)/4/3
     r_9.1e.end:
    r_10.lines.elements:
     r_10.1e: counte (r_10.lines.vertices-lines)/4/3, (r_10.lines.vertices.end-lines)/4/3
     r_10.1e.end:
    r_11.lines.elements:
     r_11.1e: counte (r_11.lines.vertices-lines)/4/3, (r_11.lines.vertices.end-lines)/4/3
     r_11.1e.end:
    r_12.lines.elements:
     r_12.1e: counte (r_12.lines.vertices-lines)/4/3, (r_12.lines.vertices.end-lines)/4/3
     r_12.1e.end:
    r_13.lines.elements:
     r_13.1e: counte (r_13.lines.vertices-lines)/4/3, (r_13.lines.vertices.end-lines)/4/3
     r_13.1e.end:
    lines.elements.end:
   lines.indices:
    r_1.lines.indices:
     r_1.1i dq r_1.1e-lines.elements
    r_2.lines.indices:
     r_2.1i dq r_2.1e-lines.elements
    r_3.lines.indices:
     r_3.1i dq r_3.1e-lines.elements
    r_4.lines.indices:
     r_4.1i dq r_4.1e-lines.elements
    r_5.lines.indices:
     r_5.1i dq r_5.1e-lines.elements
    r_6.lines.indices:
     r_6.1i dq r_6.1e-lines.elements
    r_7.lines.indices:
     r_7.1i dq r_7.1e-lines.elements
    r_8.lines.indices:
     r_8.1i dq r_8.1e-lines.elements
    r_9.lines.indices:
     r_9.1i dq r_9.1e-lines.elements
    r_10.lines.indices:
     r_10.1i dq r_10.1e-lines.elements
    r_11.lines.indices:
     r_11.1i dq r_11.1e-lines.elements
    r_12.lines.indices:
     r_12.1i dq r_12.1e-lines.elements
    r_13.lines.indices:
     r_13.1i dq r_13.1e-lines.elements
   lines.counts:
    r_1.lines.counts:
     r_1.1c dd (r_1.1e.end-r_1.1e)/2
     r_1.lines.counts.end:
    r_2.lines.counts:
     r_2.1c dd (r_2.1e.end-r_2.1e)/2
     r_2.lines.counts.end:
    r_3.lines.counts:
     r_3.1c dd (r_3.1e.end-r_3.1e)/2
     r_3.lines.counts.end:
    r_4.lines.counts:
     r_4.1c dd (r_4.1e.end-r_4.1e)/2
     r_4.lines.counts.end:
    r_5.lines.counts:
     r_5.1c dd (r_5.1e.end-r_5.1e)/2
     r_5.lines.counts.end:
    r_6.lines.counts:
     r_6.1c dd (r_6.1e.end-r_6.1e)/2
     r_6.lines.counts.end:
    r_7.lines.counts:
     r_7.1c dd (r_7.1e.end-r_7.1e)/2
     r_7.lines.counts.end:
    r_8.lines.counts:
     r_8.1c dd (r_8.1e.end-r_8.1e)/2
     r_8.lines.counts.end:
    r_9.lines.counts:
     r_9.1c dd (r_9.1e.end-r_9.1e)/2
     r_9.lines.counts.end:
    r_10.lines.counts:
     r_10.1c dd (r_10.1e.end-r_10.1e)/2
     r_10.lines.counts.end:
    r_11.lines.counts:
     r_11.1c dd (r_11.1e.end-r_11.1e)/2
     r_11.lines.counts.end:
    r_12.lines.counts:
     r_12.1c dd (r_12.1e.end-r_12.1e)/2
     r_12.lines.counts.end:
    r_13.lines.counts:
     r_13.1c dd (r_13.1e.end-r_13.1e)/2
     r_13.lines.counts.end:
  ; Lineloops
   lineloops:
    r_1.lineloops.vertices:
    lineloops.end:
   lineloops.elements:
    r_1.lineloops.elements:
    lineloops.elements.end:
   lineloops.indices:
    r_1.lineloops.indices:
   lineloops.counts:
    r_1.lineloops.counts:
     r_1.lineloops.counts.end:
  ; Linestrips
   linestrips:
    linestrips.end:
   linestrips.elements:
    linestrips.elements.end:
   linestrips.indices:
   linestrips.counts: