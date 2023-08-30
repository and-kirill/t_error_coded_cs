% Data obtaied from figure (pixels)
scale = 239.4;

X = [
    25   1095 1011;
    50   1190 1107;
    75   1276 1194;
    100  1275 1358;
    125  1442 1359;
    150  1609 1694;
    175  1754 1837;
    200  1861 1945;
    225  2041 2124;
    250  2213 2297;
    275  2420 2502;
    300  2681 2765;
    ];


marker_height = abs(X(:, 2) - X(:, 3));
fprintf('Mean marker height: %1.3f, max: %d, min: %d\n', ...
    mean(marker_height), max(marker_height), min(marker_height) ...
    );
ebno_db = (X(:, 2) + X(:, 3)) / (2 * scale);

fprintf('Ka EBNO\n');
K = X(:, 1);
for i = 1:length(K)
    fprintf('%04d %1.3e\n', K(i), ebno_db(i));
end