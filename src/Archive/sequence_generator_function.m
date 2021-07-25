function [outputArg1,outputArg2] = sequence_generator_function(i_index, j_index, k_index, l_index, h_index, data_index, Day)

S = SeqGen(Day);
while(~isOKSeq(S)) 
    S = SeqGen(Day);
end

% Save sequence
save(['../subjects','/S_', num2str(i_index), '_', num2str(j_index), '_', num2str(k_index), '_', num2str(l_index), '_', num2str(h_index), '/D_', num2str(data_index) ,'/Sq_Day_', num2str(Day)], 'S');

function isOK = isOKSeq(S)
    isOK = true;
    counter = 0;
    last = 0;
    current = 0;
    for i= 1:size(S,2)
        if(S(1,i) < 3)
            current = mod(S(2,i), 10);
        elseif(S(1,i) == 3)
            counter = 0;
        elseif(S(1,i) == 4)
            current = mod(S(2,i), 10);
        elseif(S(1,i) == 5)
            current = mod(floor(S(2,i)/10), 10);
        elseif(S(1,i) == 6)
            current = mod(floor(S(2,i)/10), 10);
        elseif(S(1,i) == 8)
            counter = 0;
        end
        
        if(last == current)
            counter = counter + 1;
        else
            counter = 0;
            last = current;
        end
        
        if(counter >=3)
            isOK = false;
            break
        end
    end
end

function S = SeqGen(Day) 

% This trialas on left side
left = [1 2 5 6]; 

if (Day == 1) % We should generate 24 passive viewing trials
    
    S = zeros(2,24); % Output matrix
    S(1,:) = 5; % All are passive viewing
    A = [];
    for k=1:3
        A = [A randperm(8)];
    end
    S(2,:) = A;
    
    for fr = 1:8 % Set left and right of fracktals
        index = find(S(2,:)==fr);
        index = index(randperm(3));
        for i = 1:3
            if(ismember(S(2,index(i)), left))
                S(2,index(i)) = 10*S(2,index(i)) + 1; % left side
            else
                S(2,index(i)) = 10*S(2,index(i)) + 2; % right side
            end
            if(i == 1) 
                S(2,index(i)) = 10*S(2,index(i)) + 1; % top side
            elseif(i == 2)
                S(2,index(i)) = 10*S(2,index(i)) + 2; % center side
            else
                S(2,index(i)) = 10*S(2,index(i)) + 3; % bottom side
            end
        end
    end
    
elseif (Day == 2) % We should generate 96 trials
    
    S = zeros(2,96); % Output matrix

    % Set Trials

    % Block1
    A = [11 32 51]; % force that we show
    tmp_i = A(randperm(3));

    % Threee force trials
    S(1,1) = 1;
    S(1,2) = 1;
    S(1,3) = 1;

    S(2,1) = tmp_i(1);
    S(2,2) = tmp_i(2);
    S(2,3) = tmp_i(3);

    pointer = 4; % pointer to the current item we are filling it

    available_choice_1 = A;
    available_choice_2 = [53];
    tmp_i = randperm(3);
    for i = tmp_i
        if(i ~= 3) 
            S(1, pointer) = 2; % choice 1
            item_choice_1 = randi([1 length(available_choice_1)],1,1);
            S(2, pointer) = available_choice_1(item_choice_1);
            available_choice_1(item_choice_1) = [];
            pointer = pointer + 1;
        else
            S(1, pointer) = 3; % choice 2
            item_choice_2 = randi([1 length(available_choice_2)],1,1);
            S(2, pointer) = available_choice_2(item_choice_2);
            available_choice_2(item_choice_2) = [];
            pointer = pointer + 1;
        end
    end

    % Block2
    A = [21 61 72];
    tmp_i = A(randperm(3));

    % Threee force trials
    S(1,7) = 1;
    S(1,8) = 1;
    S(1,9) = 1;

    S(2,7) = tmp_i(1);
    S(2,8) = tmp_i(2);
    S(2,9) = tmp_i(3);


    pointer = 10; % pointer to the current item we are filling it

    available_choice_1 = [available_choice_1, A];
    available_choice_2 = [available_choice_2, 63, 17, 27];
    tmp_i = randperm(3);
    for i = tmp_i
        if(i == 3) 
            S(1, pointer) = 2; % choice 1
            item_choice_1 = randi([1 length(available_choice_1)],1,1);
            S(2, pointer) = available_choice_1(item_choice_1);
            available_choice_1(item_choice_1) = [];
            pointer = pointer + 1;
        else
            S(1, pointer) = 3; % choice 2
            item_choice_2 = randi([1 length(available_choice_2)],1,1);
            S(2, pointer) = available_choice_2(item_choice_2);
            available_choice_2(item_choice_2) = [];
            pointer = pointer + 1;
        end
    end

    % Block3 (first two forces)
    A = [42, 82];
    tmp_i = A(randperm(2));
    
    S(1,13) = 1;
    S(1,14) = 1;
    
    S(2,13) = tmp_i(1);
    S(2,14) = tmp_i(2);

    available_choice_1 = [available_choice_1, A];
    available_choice_2 = [available_choice_2, 54, 64, 18, 28];

    % Now we are completly free!! :))

    pointer = 15;
    available_force = [11 21 32 42 51 61 72 82]; % 8 force

    % first fill 4 remaining trials of this block
    tmp_i = [4 randperm(3)];
    for i = tmp_i
        if(i == 4) 
            S(1, pointer) = 1; % force
            item_force = randi([1 length(available_force)],1,1);
            S(2, pointer) = available_force(item_force);
            available_force(item_force) = [];
            pointer = pointer + 1;
        elseif( i ~= 1)
            S(1, pointer) = 2; % choice 1
            item_choice_1 = randi([1 length(available_choice_1)],1,1);
            S(2, pointer) = available_choice_1(item_choice_1);
            available_choice_1(item_choice_1) = [];
            pointer = pointer + 1;
        else
            S(1, pointer) = 3; % choice 2
            item_choice_2 = randi([1 length(available_choice_2)],1,1);
            S(2, pointer) = available_choice_2(item_choice_2);
            available_choice_2(item_choice_2) = [];
            pointer = pointer + 1;
        end
    end

    % Block 4-16
    for block = 4:16
        tmp_i = [4:6 randperm(3)];    
        if(mod(block, 2) == 1)
            for i = tmp_i
                
                % fill it again :))
                if(isempty(available_force))
                    available_force = [11 21 32 42 51 61 72 82]; % 8 force
                end
                
                if(isempty(available_choice_1))
                    available_choice_1 = [11 21 32 42 51 61 72 82]; % 8 choice 1
                end
                
                if(isempty(available_choice_2))
                    available_choice_2 = [53 54 63 64 18 28 17 27]; % 8 choice 2
                end
                
                if(i > 3) 
                    S(1, pointer) = 1; % force
                    item_force = randi([1 length(available_force)],1,1);
                    S(2, pointer) = available_force(item_force);
                    available_force(item_force) = [];
                    pointer = pointer + 1;
                elseif(i ~= 3)
                    S(1, pointer) = 2; % choice 1
                    item_choice_1 = randi([1 length(available_choice_1)],1,1);
                    S(2, pointer) = available_choice_1(item_choice_1);
                    available_choice_1(item_choice_1) = [];
                    pointer = pointer + 1;
                else
                    S(1, pointer) = 3; % choice 2
                    item_choice_2 = randi([1 length(available_choice_2)],1,1);
                    S(2, pointer) = available_choice_2(item_choice_2);
                    available_choice_2(item_choice_2) = [];
                    pointer = pointer + 1;
                end
            end
        else
            for i = tmp_i
                
                % fill it again :))
                if(isempty(available_force))
                    available_force = [11 21 32 42 51 61 72 82]; % 8 force
                end
                
                if(isempty(available_choice_1))
                    available_choice_1 = [11 21 32 42 51 61 72 82]; % 8 choice 1
                end
                
                if(isempty(available_choice_2))
                    available_choice_2 = [53 54 63 64 18 28 17 27]; % 8 choice 2
                end
                
                if(i > 3) 
                    S(1, pointer) = 1; % force
                    item_force = randi([1 length(available_force)],1,1);
                    S(2, pointer) = available_force(item_force);
                    available_force(item_force) = [];
                    pointer = pointer + 1;
                elseif(i == 3)
                    S(1, pointer) = 2; % choice 1
                    item_choice_1 = randi([1 length(available_choice_1)],1,1);
                    S(2, pointer) = available_choice_1(item_choice_1);
                    available_choice_1(item_choice_1) = [];
                    pointer = pointer + 1;
                else
                    S(1, pointer) = 3; % choice 2
                    item_choice_2 = randi([1 length(available_choice_2)],1,1);
                    S(2, pointer) = available_choice_2(item_choice_2);
                    available_choice_2(item_choice_2) = [];
                    pointer = pointer + 1;
                end
            end
        end
    end
    
elseif(Day == 3) % Generate sequence for Day3 24 + 24
    
    S1 = zeros(2,24); % Output matrix
    S1(1,:) = 5; % All are passive viewing
    A = [];
    for k=1:3
        A = [A randperm(8)];
    end
    S1(2,:) = A;
    
    for fr = 1:8 % Set left and right of fracktals
        index = find(S1(2,:)==fr);
        index = index(randperm(3));
        for i = 1:3
            if(ismember(S1(2,index(i)), left))
                S1(2,index(i)) = 10*S1(2,index(i)) + 1; % left side
            else
                S1(2,index(i)) = 10*S1(2,index(i)) + 2; % right side
            end
            if(i == 1) 
                S1(2,index(i)) = 10*S1(2,index(i)) + 1; % top side
            elseif(i == 2)
                S1(2,index(i)) = 10*S1(2,index(i)) + 2; % center side
            else
                S1(2,index(i)) = 10*S1(2,index(i)) + 3; % bottom side
            end
        end
    end
    
    S2 = zeros(2,24); % Output matrix
    S2(1,:) = 2; % All are choice 1
    A = [];
    for k=1:3
        A = [A randperm(8)];
    end
    S2(2,:) = A;
    
    for fr = 1:8 % Set left and right of fracktals
        index = find(S2(2,:)==fr);
        for i = 1:3
            if(ismember(S2(2,index(i)), left))
                S2(2,index(i)) = 10*S2(2,index(i)) + 1; % left side
            else
                S2(2,index(i)) = 10*S2(2,index(i)) + 2; % right side
            end
        end
    end
    
    S = [S1 S2];
    
elseif(Day == 4) % Generate sequence for Day4! (24 choice1)
    
    S = zeros(2,24); % Output matrix
    S(1,:) = 2; % All are choice 1
    A = [];
    for k=1:3
        A = [A randperm(8)];
    end
    S(2,:) = A;
    
    for fr = 1:8 % Set left and right of fracktals
        index = find(S(2,:)==fr);
        for i = 1:3
            if(ismember(S(2,index(i)), left))
                S(2,index(i)) = 10*S(2,index(i)) + 1; % left side
            else
                S(2,index(i)) = 10*S(2,index(i)) + 2; % right side
            end
        end
    end
    
elseif (Day == 5) % We should generate 96 trials with one hemifiled (choice2')
    
    S = zeros(2,96); % Output matrix

    % Set Trials

    % Block1
    A = [11 32 51]; % force that we show
    tmp_i = A(randperm(3));

    % Threee force trials
    S(1,1) = 1;
    S(1,2) = 1;
    S(1,3) = 1;

    S(2,1) = tmp_i(1);
    S(2,2) = tmp_i(2);
    S(2,3) = tmp_i(3);

    pointer = 4; % pointer to the current item we are filling it

    available_choice_1 = A;
    available_choice_2 = [151 511];
    tmp_i = randperm(3);
    for i = tmp_i
        if(i ~= 3) 
            S(1, pointer) = 2; % choice 1
            item_choice_1 = randi([1 length(available_choice_1)],1,1);
            S(2, pointer) = available_choice_1(item_choice_1);
            available_choice_1(item_choice_1) = [];
            pointer = pointer + 1;
        else
            S(1, pointer) = 4; % choice 2'
            item_choice_2 = randi([1 length(available_choice_2)],1,1);
            S(2, pointer) = available_choice_2(item_choice_2);
            available_choice_2(item_choice_2) = [];
            pointer = pointer + 1;
        end
    end

    % Block2
    A = [21 61 72];
    tmp_i = A(randperm(3));

    % Threee force trials
    S(1,7) = 1;
    S(1,8) = 1;
    S(1,9) = 1;

    S(2,7) = tmp_i(1);
    S(2,8) = tmp_i(2);
    S(2,9) = tmp_i(3);


    pointer = 10; % pointer to the current item we are filling it

    available_choice_1 = [available_choice_1, A];
    available_choice_2 = [available_choice_2, 161, 611, 251, 521, 261, 621, 372, 732];
    tmp_i = randperm(3);
    for i = tmp_i
        if(i == 3) 
            S(1, pointer) = 2; % choice 1
            item_choice_1 = randi([1 length(available_choice_1)],1,1);
            S(2, pointer) = available_choice_1(item_choice_1);
            available_choice_1(item_choice_1) = [];
            pointer = pointer + 1;
        else
            S(1, pointer) = 4; % choice 2'
            item_choice_2 = randi([1 length(available_choice_2)],1,1);
            S(2, pointer) = available_choice_2(item_choice_2);
            available_choice_2(item_choice_2) = [];
            pointer = pointer + 1;
        end
    end

    % Block3 (first two forces)
    A = [42, 82];
    tmp_i = A(randperm(2));
    
    S(1,13) = 1;
    S(1,14) = 1;
    
    S(2,13) = tmp_i(1);
    S(2,14) = tmp_i(2);

    available_choice_1 = [available_choice_1, A];
    available_choice_2 = [available_choice_2, 382, 832, 472, 742, 482, 842];

    % Now we are completly free!! :))

    pointer = 15;
    available_force = [11 21 32 42 51 61 72 82]; % 8 force

    % first fill 4 remaining trials of this block
    tmp_i = [4 randperm(3)];
    for i = tmp_i
        if(i == 4) 
            S(1, pointer) = 1; % force
            item_force = randi([1 length(available_force)],1,1);
            S(2, pointer) = available_force(item_force);
            available_force(item_force) = [];
            pointer = pointer + 1;
        elseif( i ~= 1)
            S(1, pointer) = 2; % choice 1
            item_choice_1 = randi([1 length(available_choice_1)],1,1);
            S(2, pointer) = available_choice_1(item_choice_1);
            available_choice_1(item_choice_1) = [];
            pointer = pointer + 1;
        else
            S(1, pointer) = 4; % choice 2'
            item_choice_2 = randi([1 length(available_choice_2)],1,1);
            S(2, pointer) = available_choice_2(item_choice_2);
            available_choice_2(item_choice_2) = [];
            pointer = pointer + 1;
        end
    end

    % Block 4-16
    for block = 4:16
        tmp_i = [4:6 randperm(3)];    
        if(mod(block, 2) == 1)
            for i = tmp_i
                
                % fill it again :))
                if(isempty(available_force))
                    available_force = [11 21 32 42 51 61 72 82]; % 8 force
                end
                
                if(isempty(available_choice_1))
                    available_choice_1 = [11 21 32 42 51 61 72 82]; % 8 choice 1
                end
                
                if(isempty(available_choice_2))
                    if(rand()>0.5)
                        available_choice_2 = [151 611 521 261 372 832 742 482]; % 8 choice 2'
                    else
                        available_choice_2 = [511 161 251 621 732 382 472 842]; % 8 choice 2'
                    end
                end
                
                if(i > 3) 
                    S(1, pointer) = 1; % force
                    item_force = randi([1 length(available_force)],1,1);
                    S(2, pointer) = available_force(item_force);
                    available_force(item_force) = [];
                    pointer = pointer + 1;
                elseif(i ~= 3)
                    S(1, pointer) = 2; % choice 1
                    item_choice_1 = randi([1 length(available_choice_1)],1,1);
                    S(2, pointer) = available_choice_1(item_choice_1);
                    available_choice_1(item_choice_1) = [];
                    pointer = pointer + 1;
                else
                    S(1, pointer) = 4; % choice 2'
                    item_choice_2 = randi([1 length(available_choice_2)],1,1);
                    S(2, pointer) = available_choice_2(item_choice_2);
                    available_choice_2(item_choice_2) = [];
                    pointer = pointer + 1;
                end
            end
        else
            for i = tmp_i
                
                % fill it again :))
                if(isempty(available_force))
                    available_force = [11 21 32 42 51 61 72 82]; % 8 force
                end
                
                if(isempty(available_choice_1))
                    available_choice_1 = [11 21 32 42 51 61 72 82]; % 8 choice 1
                end
                
                if(isempty(available_choice_2))
                    if(rand()>0.5)
                        available_choice_2 = [151 611 521 261 372 832 742 482]; % 8 choice 2'
                    else
                        available_choice_2 = [511 161 251 621 732 382 472 842]; % 8 choice 2'
                    end
                end
                
                if(i > 3) 
                    S(1, pointer) = 1; % force
                    item_force = randi([1 length(available_force)],1,1);
                    S(2, pointer) = available_force(item_force);
                    available_force(item_force) = [];
                    pointer = pointer + 1;
                elseif(i == 3)
                    S(1, pointer) = 2; % choice 1
                    item_choice_1 = randi([1 length(available_choice_1)],1,1);
                    S(2, pointer) = available_choice_1(item_choice_1);
                    available_choice_1(item_choice_1) = [];
                    pointer = pointer + 1;
                else
                    S(1, pointer) = 4; % choice 2'
                    item_choice_2 = randi([1 length(available_choice_2)],1,1);
                    S(2, pointer) = available_choice_2(item_choice_2);
                    available_choice_2(item_choice_2) = [];
                    pointer = pointer + 1;
                end
            end
        end
    end
    
elseif (Day == 6) % We should generate 128 trials Like Day2 
    
    S = zeros(2,128); % Output matrix

    % Set Trials

    % Block1
    A = [11 32 51 72]; % force that we show
    tmp_i = A(randperm(4));

    % Four force trials
    S(1,1) = 1;
    S(1,2) = 1;
    S(1,3) = 1;
    S(1,4) = 1;

    S(2,1) = tmp_i(1);
    S(2,2) = tmp_i(2);
    S(2,3) = tmp_i(3);
    S(2,4) = tmp_i(4);
    
    pointer = 5; % pointer to the current item we are filling it

    available_choice_1 = A;
    available_choice_2 = [53 17];
    tmp_i = randperm(4);
    for i = tmp_i
        if(i < 3) 
            S(1, pointer) = 2; % choice 1
            item_choice_1 = randi([1 length(available_choice_1)],1,1);
            S(2, pointer) = available_choice_1(item_choice_1);
            available_choice_1(item_choice_1) = [];
            pointer = pointer + 1;
        else
            S(1, pointer) = 3; % choice 2
            item_choice_2 = randi([1 length(available_choice_2)],1,1);
            S(2, pointer) = available_choice_2(item_choice_2);
            available_choice_2(item_choice_2) = [];
            pointer = pointer + 1;
        end
    end

    % Block2
    A = [21 42 61 82];
    tmp_i = A(randperm(4));

    % Threee force trials
    S(1,9) = 1;
    S(1,10) = 1;
    S(1,11) = 1;
    S(1,12) = 1;


    S(2,9) = tmp_i(1);
    S(2,10) = tmp_i(2);
    S(2,11) = tmp_i(3);
    S(2,12) = tmp_i(4);


    pointer = 13; % pointer to the current item we are filling it

    available_choice_1 = [available_choice_1, A];
    available_choice_2 = [available_choice_2, 54 63 64 18 28 27];
    tmp_i = randperm(4);
    for i = tmp_i
        if(i < 3) 
            S(1, pointer) = 2; % choice 1
            item_choice_1 = randi([1 length(available_choice_1)],1,1);
            S(2, pointer) = available_choice_1(item_choice_1);
            available_choice_1(item_choice_1) = [];
            pointer = pointer + 1;
        else
            S(1, pointer) = 3; % choice 2
            item_choice_2 = randi([1 length(available_choice_2)],1,1);
            S(2, pointer) = available_choice_2(item_choice_2);
            available_choice_2(item_choice_2) = [];
            pointer = pointer + 1;
        end
    end

    available_force = [11 21 32 42 51 61 72 82];
    % Block 3-16
    for block = 3:16
        tmp_i = [5:8 randperm(4)];    
            for i = tmp_i

                % fill it again :))
                if(isempty(available_force))
                    available_force = [11 21 32 42 51 61 72 82]; % 8 force
                end

                if(isempty(available_choice_1))
                    available_choice_1 = [11 21 32 42 51 61 72 82]; % 8 choice 1
                end

                if(isempty(available_choice_2))
                    available_choice_2 = [53 54 63 64 18 28 17 27]; % 8 choice 2
                end

                if(i > 4) 
                    S(1, pointer) = 1; % force
                    item_force = randi([1 length(available_force)],1,1);
                    S(2, pointer) = available_force(item_force);
                    available_force(item_force) = [];
                    pointer = pointer + 1;
                elseif(i > 2)
                    S(1, pointer) = 2; % choice 1
                    item_choice_1 = randi([1 length(available_choice_1)],1,1);
                    S(2, pointer) = available_choice_1(item_choice_1);
                    available_choice_1(item_choice_1) = [];
                    pointer = pointer + 1;
                else
                    S(1, pointer) = 3; % choice 2
                    item_choice_2 = randi([1 length(available_choice_2)],1,1);
                    S(2, pointer) = available_choice_2(item_choice_2);
                    available_choice_2(item_choice_2) = [];
                    pointer = pointer + 1;
                end
            end
    end
    
elseif (Day == 7) % We should generate 128 trials Like Day2 in one hemifield
    
    S = zeros(2,128); % Output matrix

    % Set Trials

    % Block1
    A = [11 32 51 72]; % force that we show
    tmp_i = A(randperm(4));

    % Four force trials
    S(1,1) = 1;
    S(1,2) = 1;
    S(1,3) = 1;
    S(1,4) = 1;

    S(2,1) = tmp_i(1);
    S(2,2) = tmp_i(2);
    S(2,3) = tmp_i(3);
    S(2,4) = tmp_i(4);
    
    pointer = 5; % pointer to the current item we are filling it

    available_choice_1 = A;
    available_choice_2 = [151 511 372 732];
    tmp_i = randperm(4);
    for i = tmp_i
        if(i < 3) 
            S(1, pointer) = 2; % choice 1
            item_choice_1 = randi([1 length(available_choice_1)],1,1);
            S(2, pointer) = available_choice_1(item_choice_1);
            available_choice_1(item_choice_1) = [];
            pointer = pointer + 1;
        else
            S(1, pointer) = 4; % choice 2'
            item_choice_2 = randi([1 length(available_choice_2)],1,1);
            S(2, pointer) = available_choice_2(item_choice_2);
            available_choice_2(item_choice_2) = [];
            pointer = pointer + 1;
        end
    end

    % Block2
    A = [21 42 61 82];
    tmp_i = A(randperm(4));

    % Threee force trials
    S(1,9) = 1;
    S(1,10) = 1;
    S(1,11) = 1;
    S(1,12) = 1;


    S(2,9) = tmp_i(1);
    S(2,10) = tmp_i(2);
    S(2,11) = tmp_i(3);
    S(2,12) = tmp_i(4);


    pointer = 13; % pointer to the current item we are filling it

    available_choice_1 = [available_choice_1, A];
    available_choice_2 = [available_choice_2, 161 611 251 521 261 621 382 832 472 742 482 842];
    tmp_i = randperm(4);
    for i = tmp_i
        if(i < 3) 
            S(1, pointer) = 2; % choice 1
            item_choice_1 = randi([1 length(available_choice_1)],1,1);
            S(2, pointer) = available_choice_1(item_choice_1);
            available_choice_1(item_choice_1) = [];
            pointer = pointer + 1;
        else
            S(1, pointer) = 4; % choice 2'
            item_choice_2 = randi([1 length(available_choice_2)],1,1);
            S(2, pointer) = available_choice_2(item_choice_2);
            available_choice_2(item_choice_2) = [];
            pointer = pointer + 1;
        end
    end

    available_force = [11 21 32 42 51 61 72 82];
    % Block 3-16
    for block = 3:16
        tmp_i = [5:8 randperm(4)];    
            for i = tmp_i

                % fill it again :))
                if(isempty(available_force))
                    available_force = [11 21 32 42 51 61 72 82]; % 8 force
                end

                if(isempty(available_choice_1))
                    available_choice_1 = [11 21 32 42 51 61 72 82]; % 8 choice 1
                end

                if(isempty(available_choice_2))
                    available_choice_2 = [151 511 161 611 251 521 261 621 372 732 382 832 472 742 482 842]; % 16 choice 2'
                end

                if(i > 4) 
                    S(1, pointer) = 1; % force
                    item_force = randi([1 length(available_force)],1,1);
                    S(2, pointer) = available_force(item_force);
                    available_force(item_force) = [];
                    pointer = pointer + 1;
                elseif(i > 2)
                    S(1, pointer) = 2; % choice 1
                    item_choice_1 = randi([1 length(available_choice_1)],1,1);
                    S(2, pointer) = available_choice_1(item_choice_1);
                    available_choice_1(item_choice_1) = [];
                    pointer = pointer + 1;
                else
                    S(1, pointer) = 4; % choice 2'
                    item_choice_2 = randi([1 length(available_choice_2)],1,1);
                    S(2, pointer) = available_choice_2(item_choice_2);
                    available_choice_2(item_choice_2) = [];
                    pointer = pointer + 1;
                end
            end
    end
    
elseif(Day == 8) % Generate sequence for Day8 (24 choice1(same side as training) + 24 choice1(op. side) + 48 fake)
    
    S = zeros(2,72); % Output matrix
    S(1,:) = 6; % All are choice 1'
    A = [];
    for k=1:6
        A = [A randperm(12)];
    end
    S(2,:) = A;
    
    for fr = 1:8 % Set left and right of fracktals
        index = find(S(2,:)==fr);
        for i = 1:3
            if(ismember(S(2,index(i)), left))
                S(2,index(i)) = 10*S(2,index(i)) + 1; % left side
            else
                S(2,index(i)) = 10*S(2,index(i)) + 2; % right side
            end
            
            if(fr<4)
                S(2,index(i)) = 10*S(2,index(i)) + 1; % good fraktal 
            else
                S(2,index(i)) = 10*S(2,index(i)) + 2; % bad fraktal 
            end
        end
    end
    
    for fr = 1:8 % Set left and right of fracktals in other side!
        index = find(S(2,:)==fr);
        for i = 1:3
            if(ismember(S(2,index(i)), left))
                % It should be left side so we set it in right side
                S(2,index(i)) = 10*S(2,index(i)) + 2; 
            else
                % It should be right side so we set it in left side
                S(2,index(i)) = 10*S(2,index(i)) + 1;
            end
            
            if(fr<4)
                S(2,index(i)) = 10*S(2,index(i)) + 1; % good fraktal 
            else
                S(2,index(i)) = 10*S(2,index(i)) + 2; % bad fraktal 
            end
        end
    end
    
    for fr = 9:12 % Set fake fracktals randomly
        index = find(S(2,:)==fr);
        randii = randperm(6);
        for i = 1:6
            if(randii(i) > 3)
                S(2,index(i)) = 100*S(2,index(i)) + 23; 
            else
                S(2,index(i)) = 100*S(2,index(i)) + 13;
            end
        end
    end
    
elseif(Day == 9) % Generate sequence for Day9 (12 probe 2 + 12 probe 3 + 24 rest)

    % ==> a: fracktal number ( may be more than 10!) , b: 1-> left 2-> right,
    % c: 1-> good, 2-> bad, 3->novel, d: 2 -> 2 repeats, 3 -> 3 repeats

    S = zeros(2,48); % Output matrix
    
    D = [1112 2112 3212 4212 5122 6122 7222 8222 9132 10132 11232 12232
         1113 2113 3213 4213 5123 6123 7223 8223 9133 10133 11233 12233];
    
    D = D(randperm(24));
    for i = 1:48
        if (mod(i, 2) == 0)
            S(1, i) = 8;
            S(2, i) = D(i/2);
        else
            S(1, i) = 7;   
        end
    end
    
end

end

end

