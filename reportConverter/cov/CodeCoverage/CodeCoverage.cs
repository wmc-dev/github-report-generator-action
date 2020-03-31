//csc CodeCoverage.cs -reference:Microsoft.VisualStudio.Coverage.Analysis.dll

using Microsoft.VisualStudio.Coverage.Analysis;

namespace CoverageConverter
{
    class Program
    {
        static void Main(string[] args)
        {
            using (CoverageInfo info = CoverageInfo.CreateFromFile(
                args[0], 
                new string[] { System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location)}, 
                new string[] { }))
            {
                CoverageDS data = info.BuildDataSet();
                data.WriteXml(args[0] + ".xml");
            }
        }
    }
}