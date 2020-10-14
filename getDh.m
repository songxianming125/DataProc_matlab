function dh= getDh()
shotno=405;
% shotno=342;
% shotno=363;
ip=exl50db(shotno,'ip');
fdo=-exl50db(shotno,'fdo');
fdi=exl50db(shotno,'fdi');
fuo=exl50db(shotno,'fuo');
fui=exl50db(shotno,'fui');

df=((fuo+fdo)-(fui+fdi))/2;
figure
hold on
plot(ip)
plot(df)
end

