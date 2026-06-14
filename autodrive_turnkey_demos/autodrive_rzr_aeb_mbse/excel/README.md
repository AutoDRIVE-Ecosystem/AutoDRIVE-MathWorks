# Export Architecture to Microsoft Excel

In System Composer, an architecture is fully defined by three sets of information:
- Component information
- Port information
- Connection information

Architectures can be imported/exported when this information is defined in or converted into MATLAB tables.

## Example

Change working directory to this folder and then execute the following commands:

```matlab
exportedSet = systemcomposer.exportModel('AutoDRIVE_RZR_AEB');

saveToExcel("AutoDRIVE_RZR_AEB", exportedSet);
```

## Reference

MathWorks Documentation: [Import and Export Architectures](https://www.mathworks.com/help/systemcomposer/ug/arch-import-export.html)