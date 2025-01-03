import ezdxf
import geopandas as gpd
from shapely.geometry import Point, LineString, Polygon
import os

def parse_dxf_to_gis(input_file, output_file, output_format='GeoJSON'):
    """
    Converts a DXF file to a GIS format (GeoJSON or Shapefile).
    
    :param input_file: Path to the input DXF file.
    :param output_file: Path to the output GIS file (GeoJSON or Shapefile).
    :param output_format: Desired output format (GeoJSON or Shapefile). Default is GeoJSON.
    """
    # Read the DXF file
    try:
        doc = ezdxf.readfile(input_file)
    except IOError:
        print(f"Error: File {input_file} not found.")
        return
    except ezdxf.DXFStructureError:
        print(f"Error: Invalid DXF file {input_file}.")
        return

    features = []

    # Extract LINE entities from the DXF file and convert them to geometries
    for entity in doc.modelspace().query('LINE'):
        line = LineString([(entity.dxf.start.x, entity.dxf.start.y), 
                           (entity.dxf.end.x, entity.dxf.end.y)])
        features.append(line)

    # Create a GeoDataFrame
    gdf = gpd.GeoDataFrame(geometry=features)

    # Convert and save to the desired output format
    if output_format.lower() == 'geojson':
        gdf.to_file(output_file, driver='GeoJSON')
    elif output_format.lower() == 'shp':
        gdf.to_file(output_file, driver='ESRI Shapefile')
    else:
        print(f"Error: Unsupported output format '{output_format}'.")

    print(f"Conversion complete. Output saved to {output_file}")


if __name__ == "__main__":
    # Specify input and output files
    input_dxf = 'input.dxf'  # Change this to your DXF file path
    output_gis = 'output.geojson'  # Change this to your desired output file path

    # Call the function to convert DXF to GIS
    parse_dxf_to_gis(input_dxf, output_gis, output_format='GeoJSON')  # Change to 'Shapefile' if needed
