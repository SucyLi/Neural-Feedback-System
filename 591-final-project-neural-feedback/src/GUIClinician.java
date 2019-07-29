import java.io.IOException;
import java.util.ArrayList;

public class GUIClinician {
	private int nx;
	private int ny;
	private int nz;
	private int task;

	public void draw(ArrayList<String> actualMoves, ArrayList<String> predictedMoves) {
		NiftiVolume volume;
		try {
			volume = NiftiVolume.read("fMRI_test.nii");
			nx = volume.header.dim[1];
			ny = volume.header.dim[2];
			nz = volume.header.dim[3];
			task = volume.header.dim[4];
			// 64, 64, 30, 72
			// System.out.println("dims: " + nx + " " + ny + " " + nz + " " + task);

			// PennDraw
			int scaleFactor = 4;
			PennDraw.setCanvasSize(nx * scaleFactor, ny * scaleFactor);
			PennDraw.enableAnimation(12); // 30 / 2.5

			for (int t = 0; t < task; t++) {
				String actualLabel = actualMoves.get(t);
				String predLabel = predictedMoves.get(t);
				for (int z = 0; z < nz; z++) {
					double slice[][] = new double[nx][ny];
					double maxIntensity = 0;
					for (int x = 0; x < nx; x++) {
						for (int y = 0; y < ny; y++) {
							slice[x][y] = volume.data.get(x, y, z, t);
							if (slice[x][y] > maxIntensity) {
								maxIntensity = slice[x][y];
							}
						}
					}
					// Normalize data to gray scale
					for (int x = 0; x < nx; x++) {
						for (int y = 0; y < ny; y++) {
							slice[x][y] = slice[x][y] / maxIntensity * 255;
						}
					}
					PennDraw.clear(PennDraw.BLACK);
					for (int i = 0; i < nx; i++) {
						for (int j = 0; j < ny; j++) {
							int pixelValue = (int) slice[i][j];
							PennDraw.setPenColor(pixelValue, pixelValue, pixelValue);
							double xCoordinate = 1.0 / (nx) + (double) i / (nx);
							double yCoordinate = 1.0 / (ny) + (double) j / (ny);
							PennDraw.filledSquare(xCoordinate, yCoordinate, 2.0 / (nx * scaleFactor));
						}
					}
					PennDraw.setPenColor(PennDraw.WHITE);
					PennDraw.setFontSize(14);
					PennDraw.text(0.25, 0.94, "Expected: " + actualLabel);
					// if wrong, red, if correct, green
					if (actualLabel.equals(predLabel)) {
						PennDraw.setPenColor(PennDraw.GREEN);
					} else {
						PennDraw.setPenColor(PennDraw.BOOK_RED);
					}
					PennDraw.setFontSize(14);
					PennDraw.text(0.75, 0.94, "Detected: " + predLabel);

					PennDraw.advance();
				}
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
