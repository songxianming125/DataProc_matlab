profile on
% tic
% piApprox=calpi;
% piApprox=calpi;
% piApprox=calpi;
% piApprox=calpi;
% t2=toc
[y,t]=hl2adb(11617,'ep01');
% [y,t]=hl2adb(11617,'ep01');
% [y,t]=hl2adb(11617,'ep01');
% [y,t]=hl2adb(11617,'ep01');
% t2=toc


%cmd code here

% PATH D:\matlab\toolbox\distcomp\bin; %PATH%
% mdce install %��װ����
% mdce start %��������
% startjobmanager -name matlabsky -v  %����һ����Ϊmatlabsky����ҵ�������
% startworker    -name worker1 
% nodestatus



% for j=1:10
jm = findResource('scheduler','type','jobmanager', 'Name', 'matlabsky'); %�ҳ�PC����Ч�ķֲ�
job = createJob(jm);
% 
% % Ϊ��ҵ��������������
% 
task1 = createTask(job, @calpi, 1);
task2 = createTask(job, @calpi, 1);
task3 = createTask(job, @calpi, 1);
task4 = createTask(job, @calpi, 1);



% task1 = createTask(job, @hl2adb, 2,{11617,'it'});
% task2 = createTask(job, @hl2adb, 2,{11617,'it'});
% task3 = createTask(job, @hl2adb, 2,{11617,'it'});
% task4 = createTask(job, @hl2adb, 2,{11617,'it'});

% task1 = createTask(job, @hl2adb, 2,{11617,'ep01'});
% task2 = createTask(job, @hl2adb, 2,{11617,'ep01'});
% task3 = createTask(job, @hl2adb, 2,{11617,'ep01'});
% task4 = createTask(job, @hl2adb, 2,{11617,'ep01'});
% end






% 
% % �ύ����,�ȴ����
% t0=toc
% tic
submit(job);
% promote(jm, job);

% waitForState(job, 'queued');
% waitForState(job, 'running');
waitForState(job, 'finished');

%�õ��������ʾ 

results = getAllOutputArguments(job);
% t=results{1,2};
% y=results{1,1};
% t=results{1,2};
% y=results{1,1};
% t=results{1,2};
% y=results{1,1};
% t=results{1,2};
% y=results{1,1};

t1=toc

tic
% [y,t]=hl2adb(11617,'it','mmc');
% [y,t]=hl2adb(11617,'it','mmc');
% [y,t]=hl2adb(11617,'it','mmc');
% [y,t]=hl2adb(11617,'it','mmc');
% [y,t]=hl2adb(11617,'it','mmc');
% [y,t]=hl2adb(11617,'it','mmc');
% [y,t]=hl2adb(11617,'it','mmc');
% [y,t]=hl2adb(11617,'it','mmc');

% [y,t]=hl2adb(11617,'@prad');
% [y,t]=hl2adb(11617,'@prad');
% [y,t]=hl2adb(11617,'@prad');
% [y,t]=hl2adb(11617,'@prad');
% [y,t]=hl2adb(11617,'@prad');
% [y,t]=hl2adb(11617,'@prad');
% [y,t]=hl2adb(11617,'@prad');
% [y,t]=hl2adb(11617,'@prad');
% [y,t]=hl2adb(11617,'it');
% [y,t]=hl2adb(11617,'it');
% [y,t]=hl2adb(11617,'it');
% [y,t]=hl2adb(11617,'it');
% [y,t]=hl2adb(11617,'it');
% [y,t]=hl2adb(11617,'it');
% [y,t]=hl2adb(11617,'it');
t2=toc
profile off
% for i = 1 : 4
% 
% %disp(results{i})
% 
% end                  

