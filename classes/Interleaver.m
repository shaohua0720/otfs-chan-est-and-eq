% Copyright (c) 2021, KDDI Research, Inc. and KDDI Corp. All rights reserved.

classdef Interleaver < matlab.System
    
    properties
        % Input properties
        InterleaverIndicesSource;
        InputLength;  % for random interleaver
        InterleaverRandomSeed;
        Type; % 'Vector', 'MatRow','MatCol'
        
        % Initialized properties
        InterleaverIndices;
    end
    
    methods
        function this = Interleaver(varargin)
            setProperties(this, nargin, varargin{:}, ...
                'InterleaverIndicesSource', ...
                'InputLength', ...
                'InterleaverRandomSeed',...
                'Type');
            
            switch this.InterleaverIndicesSource
                case 'Random'
                    this.InterleaverIndices = randintrlv(1:this.InputLength, this.InterleaverRandomSeed);
            end
        end
        
        function out = interleave(this, in)
            switch this.Type
                case {'Vector'}
                    len = length(in(:));
                    assert(len==this.InputLength,'error: Vector length does not match!');
                    out = intrlv(in, this.InterleaverIndices);
                case {'MatRow'}
                    [m,~]=size(in);
                    assert(m==this.InputLength,'error: Matrix Rows do not match!');
                    out = intrlv(in, this.InterleaverIndices);
                case 'MatCol'
                    [~,n]=size(in);
                    assert(n==this.InputLength,'error: Matrix Coloumns do not match!');
                    transpose_in = in.';
                    data = intrlv(transpose_in, this.InterleaverIndices);
                    out = data.';
            end
        end
        
        function out = deinterleave(this, in)
            switch this.Type
                case {'Vector'}
                    len = length(in(:));
                    assert(len==this.InputLength,'error: Vector length does not match!');
                    out = deintrlv(in, this.InterleaverIndices);
                case{'MatRow'}
                    [m,~]=size(in);
                    assert(m==this.InputLength,'error: Matrix Rows do not match!');
                    out = deintrlv(in, this.InterleaverIndices);
                case 'MatCol'
                    [~,n]=size(in);
                    assert(n==this.InputLength,'error: Matrix Coloumns do not match!');
                    transpose_in = in.';
                    data = deintrlv(transpose_in, this.InterleaverIndices);
                    out = data.';
            end
        end
    end
end