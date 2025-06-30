'use client';

import React, { useState } from 'react';

import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Plus } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { AccountTable } from '@/components/accountTable';
import { UnitsTable } from '@/components/unitTable';
import { StatisticCards } from '@/components/statisticsCard';
import { Role } from '@/types';
import useManageAccounts from '@/hooks/useManageAccounts';
import { Dialog, DialogTrigger } from '@/components/ui/dialog';
import AddDriverModal from '@/components/addDriverModal';

const ManageAccount = () => {
    const { accounts, units, assignDriverToUnit } = useManageAccounts();

    const [openDriverModal, setOpenDriverModal] = React.useState(false);

    const tabs = [{ name: 'Accounts' }, { name: 'Units' }];

    const [filterRole, setFilterRole] = useState<Role | 'all'>('all');

    const filteredAccounts = accounts.filter((acc) => (filterRole === 'all' ? true : acc.role === filterRole));
    return (
        <div className='p-5 w-full h-screen flex space-x-5'>
            <div className='w-1/4 rounded-2xl p-5 overflow-y-auto space-y-6'>
                <div className='w-full flex justify-between items-center'>
                    <h2 className='text-2xl font-semibold mb-2'>Account & Units Overview</h2>
                </div>
                <StatisticCards accounts={accounts} units={units} />
            </div>

            <div className='w-3/4 h-full bg-background rounded-2xl overflow-hidden relative p-5 flex flex-col'>
                <Tabs defaultValue={tabs[0].name} className='w-full flex flex-col flex-grow'>
                    <TabsList className='p-0 bg-background justify-start border-b rounded-none space-x-2 mb-3'>
                        {tabs.map((tab) => (
                            <TabsTrigger key={tab.name} value={tab.name} className='rounded-none bg-background h-full data-[state=active]:shadow-none border-b-2 border-transparent data-[state=active]:border-b-primary'>
                                <code className='text-lg'>{tab.name}</code>
                            </TabsTrigger>
                        ))}
                    </TabsList>

                    <TabsContent value='Accounts' className='flex flex-col flex-grow overflow-y-auto'>
                        <div className='flex space-x-3 items-center justify-between mb-4 px-4 py-2'>
                            <div className=' flex space-x-3'>
                                {['all', 'COMMUTER', 'DRIVER', 'ADMIN'].map((r) => (
                                    <Button key={r} onClick={() => setFilterRole(r as Role | 'all')} className={`px-4 py-5 rounded ${filterRole === r ? 'bg-primary text-white' : 'bg-gray-200'}`}>
                                        {r.charAt(0).toUpperCase() + r.slice(1)}
                                    </Button>
                                ))}
                            </div>
                            <Dialog open={openDriverModal} onOpenChange={setOpenDriverModal}>
                                <DialogTrigger asChild>
                                    <Button className='text-background px-4 py-5'>
                                        Add Driver <Plus />
                                    </Button>
                                </DialogTrigger>
                                <AddDriverModal setOpen={setOpenDriverModal} />
                            </Dialog>
                        </div>

                        <AccountTable filteredAccounts={filteredAccounts} units={units} assignDriverToUnit={assignDriverToUnit} />
                    </TabsContent>

                    <TabsContent value='Units' className='overflow-y-auto'>
                        <div className='flex justify-between items-center mb-4'>
                            <h3 className='text-xl font-semibold mb-3'>Units List</h3>
                            <Button className='text-background px-4 py-5'>
                                Add Unit <Plus />
                            </Button>
                        </div>
                        <UnitsTable units={units} drivers={accounts} />
                    </TabsContent>
                </Tabs>
            </div>
        </div>
    );
};

export default ManageAccount;
