import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Account, Unit } from '@/types';

export function UnitsTable({ units, drivers }: { units: Unit[]; drivers: Account[] }) {
    return (
        <div className='overflow-x-auto'>
            <Table className='min-w-full'>
                <TableHeader>
                    <TableRow className='h-12'>
                        <TableHead className='text-xs sm:text-sm h-12'>Unit Name</TableHead>
                        <TableHead className='text-xs sm:text-sm hidden sm:table-cell h-12'>Bus Number</TableHead>
                        <TableHead className='text-xs sm:text-sm hidden md:table-cell h-12'>Plate Number</TableHead>
                        <TableHead className='text-xs sm:text-sm hidden lg:table-cell h-12'>Assigned Driver</TableHead>
                    </TableRow>
                </TableHeader>
                <TableBody>
                    {units.length === 0 ? (
                        <TableRow className='h-12'>
                            <TableCell colSpan={4} className='text-center italic text-muted-foreground text-xs sm:text-sm h-12'>
                                No units found.
                            </TableCell>
                        </TableRow>
                    ) : (
                        units.map((unit) => (
                            <TableRow key={unit.id} className='h-12'>
                                <TableCell className='font-medium text-xs sm:text-sm h-12'>
                                    <div className='flex flex-col justify-center h-full'>
                                        <div className='font-medium'>{unit.name}</div>
                                        <div className='text-xs text-muted-foreground sm:hidden'>
                                            {unit.bus_number || '-'} • {unit.plate_number || '-'}
                                        </div>
                                        <div className='text-xs text-muted-foreground lg:hidden'>{unit.assignedDriverId ? drivers.find((d) => d.id === unit.assignedDriverId)?.name || 'Unknown' : 'None'}</div>
                                    </div>
                                </TableCell>
                                <TableCell className='text-xs sm:text-sm hidden sm:table-cell h-12 flex items-center'>{unit.bus_number || '-'}</TableCell>
                                <TableCell className='text-xs sm:text-sm hidden md:table-cell h-12 flex items-center'>{unit.plate_number || '-'}</TableCell>
                                <TableCell className='text-xs sm:text-sm hidden lg:table-cell h-12 flex items-center'>
                                    {unit.assignedDriverId
                                        ? drivers.find((d) => {
                                              return d.id === unit.assignedDriverId;
                                          })?.name || 'Unknown'
                                        : 'None'}
                                </TableCell>
                            </TableRow>
                        ))
                    )}
                </TableBody>
            </Table>
        </div>
    );
}
