MODULE Module1
    CONST robtarget P0:=[[364.353829072,0,594],[0.5,0,0.866025404,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P2B:=[[360.022653153,0,473.726196092],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P1B:=[[388.755601806,0,338.420809037],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P3B:=[[-50.206591399,470.402076052,451.620152637],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P4B:=[[-50.206591399,470.402076052,325.966309799],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P2S:=[[359.130975003,0,443.778021736],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P1S:=[[361.332509941,0,254.842738956],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P3S:=[[-55.454860484,-460.39542717,433.082453731],[0,0,1,0],[-2,0,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P4S:=[[-55.454860484,-460.39542717,248.927934739],[0,0,1,0],[-2,0,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	PERS tooldata subcionador_pro:=[TRUE,[[0,0,0],[1,0,0,0]],[2,[0,0,1],[1,0,0,0],0,0,0]];
    !***********************************************************
    !
    ! Module:  Module1
    !
    ! Description:
    !   <Pick and Place de dos diferentes latas>
    !
    ! Author: Kenneth
    !
    ! Version: 1.0
    !
    !***********************************************************
    
    
    !***********************************************************
    !
    ! Procedure main
    !
    !   This is the entry point of your program
    !
    !***********************************************************
    PROC main()
        !Aqui pongo las señales de agarrar y soltar las latas en 0, así cada vez que se inicia, empiezan en 0
        SetDO CogerBigRob,0;
        SetDO DejarBigRob,0;
        SetDO CogerSmallRob,0;
        SetDO DejarSmallRob,0;
        !Aquí pongo en marcha la cinta, son dos porque para evitar cualquier error hice que cada lata actuara 
        !como si se movieran en cintas diferentes
        SetDO MarchaRob,1;
        SetDO MarchaSRob,1;
        SetDO Cinta1Rob,1;
        SetDO Cinta1SRob,1;
        SetDO Cinta2BigRob,0;
        SetDO Cinta2SmallRob,0;
        !Apenas el sensor que tiene contacto con los dos tipos de latas recibe una señal, para la cinta para 
        !realizar la función piezas
        WaitDI Sensor1SmallRob,1;
        SetDO Cinta1Rob,0;
        SetDO Cinta1SRob,0;
        piezas;
    ENDPROC
    PROC robotBig()
        !Trayectoria para las latas grandes
        MoveJ P0,v1000,z100,subcionador_pro\WObj:=wobj0;
        MoveJ P2B,v1000,z100,subcionador_pro\WObj:=wobj0;
        MoveL P1B,v1000,fine,subcionador_pro\WObj:=wobj0;
        SetDO CogerBigRob,1;
        MoveL P2B,v1000,z100,subcionador_pro\WObj:=wobj0;
        MoveJ P0,v1000,z100,subcionador_pro\WObj:=wobj0;
        MoveJ P3B,v1000,z100,subcionador_pro\WObj:=wobj0;
        MoveL P4B,v1000,fine,subcionador_pro\WObj:=wobj0;
        SetDO DejarBigRob,1;
        SetDO Cinta2BigRob,1;
        MoveL P3B,v1000,z100,subcionador_pro\WObj:=wobj0;
        MoveJ P0,v1000,z100,subcionador_pro\WObj:=wobj0;
        WaitDI Sensor2BigRob,1;
        SetDO Cinta2BigRob,0;
        SetDO Cinta1Rob,1;
    ENDPROC
    PROC robotSmall()
        !Trayectoria para las latas chicas
        MoveJ P0,v1000,z100,subcionador_pro\WObj:=wobj0;
        MoveJ P2S,v1000,z100,subcionador_pro\WObj:=wobj0;
        MoveL P1S,v1000,fine,subcionador_pro\WObj:=wobj0;
        SetDO CogerSmallRob,1;
        MoveL P2S,v1000,z100,subcionador_pro\WObj:=wobj0;
        MoveJ P0,v1000,z100,subcionador_pro\WObj:=wobj0;
        MoveJ P3S,v1000,z100,subcionador_pro\WObj:=wobj0;
        MoveL P4S,v1000,fine,subcionador_pro\WObj:=wobj0;
        SetDO DejarSmallRob,1;
        SetDO Cinta2SmallRob,1;
        MoveL P3S,v1000,z100,subcionador_pro\WObj:=wobj0;
        MoveJ P0,v1000,z100,subcionador_pro\WObj:=wobj0;
        WaitDI Sensor2SmallRob,1;
        SetDO Cinta2SmallRob,0;
        SetDO Cinta1Rob,1;
    ENDPROC
   PROC piezas()
       !Esta función es para diferenciar cual pieza se va a agarrar
       !Si los dos sensores son activados se ejecuta la función robotBig, que es de la trayectoria de las
       !latas grandes y sensar2 que es para poner los valores en su forma inicial y poder tener un ciclo
       IF Sensor1SmallRob=1 AND Sensor1BigRob=1 THEN
           robotBig;
           sensar2;
        !Si solo se activa un sensor se ejecuta la función robotSmall, que es de la trayectoria de las latas
        !pequeñas y sensar1 que es para poner los valores en su forma inicial y poder tener un ciclo
        ELSEIF Sensor1SmallRob=1 AND Sensor1BigRob=0 THEN
            robotSmall;
            sensar1;
       ENDIF
    ENDPROC
   PROC sensar1()
       !si es activado el sensor final de la cinta de latas chicas se ejecuta
       !nuevamente el main
    IF Sensor2SmallRob=1 THEN
            main;
    ENDIF 
   ENDPROC
   PROC sensar2()
       !si es activado el sensor final de la cinta de latas grandes se ejecuta
       !nuevamente el main
    IF Sensor2BigRob=1 THEN 
            main;
    ENDIF 
   ENDPROC
ENDMODULE