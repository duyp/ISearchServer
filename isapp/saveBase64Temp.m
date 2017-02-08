function file = saveBase64Temp(base64img)
    done = 0;
    while ~done
        try
            tempDir = 'C:\InstanceSearchTemp\';
            
            s = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
            b = 1;
            while b == 1
                try
                    randFileName = strcat(s( round( rand(1,5)*62 + 1)),'.jpg');
                    b = 0;
                catch
                    b = 1;
                    continue;
                end
            end
            file = strcat(tempDir,randFileName);
            base64 = sun.misc.BASE64Decoder;
            img = javaMethod('decodeBuffer',base64,base64img);
            f = java.io.File(tempDir,randFileName);
            fos = java.io.FileOutputStream(f);
            javaMethod('write',fos,img);
            javaMethod('flush',fos);
            javaMethod('close',fos);
            done = 1; % done
        catch
            done = 0;
            continue;
        end
    end
end