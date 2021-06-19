function F2C
e='Please Input number to F:';
F=input(e);
a=isempty(F);
while(a==0)
        C=(F-32)/1.8;
        d=['C is ',num2str(C),'.'];
        disp(d);
        F=input(e);
        a=isempty(F);
end
f='Input is end.';
disp(f);
end

