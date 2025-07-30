'use client';

import React, { useEffect, useRef, useState } from 'react';

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
import AddUnitModal from '@/components/addUnitModal';

const ManageAccount = () => {
    const accountRef = useRef<HTMLDivElement>(null);
    const unitRef = useRef<HTMLDivElement>(null);
    const [isLoadingAccounts, setIsLoadingAccounts] = useState(false);
    const [isLoadingUnits, setIsLoadingUnits] = useState(false);
    const hasCheckedAutoLoad = useRef(false);

    const { accounts, units, assignDriverToUnit, total, commuterCount, driverCount, adminCount, loadMoreUsers, loadMoreUnits, userCursor, lastFetchedCursor } = useManageAccounts();

    const [openDriverModal, setOpenDriverModal] = useState(false);
    const [openUnitModal, setOpenUnitModal] = useState(false);

    const tabs = [{ name: 'Accounts' }, { name: 'Units' }];

    const [filterRole, setFilterRole] = useState<Role | 'all'>('all');

    const filteredAccounts = accounts.filter((acc) => (filterRole === 'all' ? true : acc.role === filterRole));

    useEffect(() => {
        const container = accountRef.current;
        if (!container) {
            return;
        }

        let lastScrollHeight = container.scrollHeight;

        const checkIfMoreContentNeeded = () => {
            if (isLoadingAccounts || hasCheckedAutoLoad.current) return;

            const hasScrollbar = container.scrollHeight > container.clientHeight;
            const isAtBottom = container.scrollHeight - container.scrollTop - container.clientHeight <= 100;

            if (!hasScrollbar && isAtBottom) {
                setIsLoadingAccounts(true);
                loadMoreUsers();
                hasCheckedAutoLoad.current = true;
            }
        };

        const handleScroll = () => {
            if (isLoadingAccounts) return;

            const isAtBottom = container.scrollHeight - container.scrollTop - container.clientHeight <= 100;

            if (isAtBottom && (container.scrollHeight !== lastScrollHeight || (userCursor && lastFetchedCursor.current !== userCursor))) {
                setIsLoadingAccounts(true);
                loadMoreUsers();
                lastScrollHeight = container.scrollHeight;
            }
        };

        const checkTimeout = setTimeout(checkIfMoreContentNeeded, 100);

        container.addEventListener('scroll', handleScroll);

        return () => {
            container.removeEventListener('scroll', handleScroll);
            clearTimeout(checkTimeout);
        };
    }, [accounts.length, loadMoreUsers, isLoadingAccounts]);

    useEffect(() => {
        setIsLoadingAccounts(false);
        hasCheckedAutoLoad.current = false;
    }, [accounts]);

    useEffect(() => {
        const container = unitRef.current;
        if (!container) return;

        const checkIfMoreContentNeeded = () => {
            if (isLoadingUnits) return;

            const hasScrollbar = container.scrollHeight > container.clientHeight;
            const isAtBottom = container.scrollHeight - container.scrollTop - container.clientHeight <= 100;

            if (!hasScrollbar && isAtBottom) {
                setIsLoadingUnits(true);
                loadMoreUnits();
            }
        };

        const handleScroll = () => {
            if (isLoadingUnits) return;

            const isAtBottom = container.scrollHeight - container.scrollTop - container.clientHeight <= 100;
            if (isAtBottom) {
                setIsLoadingUnits(true);
                loadMoreUnits();
            }
        };

        const checkTimeout = setTimeout(checkIfMoreContentNeeded, 100);

        container.addEventListener('scroll', handleScroll);

        return () => {
            container.removeEventListener('scroll', handleScroll);
            clearTimeout(checkTimeout);
        };
    }, [units.length, loadMoreUnits, isLoadingUnits]);

    useEffect(() => {
        setIsLoadingUnits(false);
    }, [units]);

    return (
        <div className='p-2 sm:p-4 lg:p-5 w-full h-screen flex flex-col lg:flex-row lg:space-x-5 space-y-4 lg:space-y-0'>
            <div className='w-full lg:w-1/4 h-full rounded-2xl p-3 sm:p-5 flex flex-col'>
                <div className='w-full flex justify-between items-center mb-4'>
                    <h2 className='text-xl sm:text-2xl font-semibold'>Account & Units Overview</h2>
                </div>
                <div className='flex-1 overflow-y-auto'>
                    <StatisticCards units={units} total={total} commuterCount={commuterCount} driverCount={driverCount} adminCount={adminCount} />
                </div>
            </div>

            <div className='w-full lg:w-3/4 h-full bg-background rounded-2xl overflow-hidden relative p-3 sm:p-5 flex flex-col'>
                <Tabs defaultValue={tabs[0].name} className='w-full h-full flex flex-col'>
                    <TabsList className='p-0 bg-background justify-start border-b rounded-none space-x-1 sm:space-x-2 mb-3 overflow-x-auto flex-shrink-0'>
                        {tabs.map((tab) => (
                            <TabsTrigger key={tab.name} value={tab.name} className='rounded-none bg-background h-full data-[state=active]:shadow-none border-b-2 border-transparent data-[state=active]:border-b-primary whitespace-nowrap'>
                                <code className='text-sm sm:text-lg'>{tab.name}</code>
                            </TabsTrigger>
                        ))}
                    </TabsList>

                    <TabsContent value='Accounts' className='flex flex-col flex-1 h-0'>
                        <div className='flex flex-col sm:flex-row space-y-3 sm:space-y-0 sm:space-x-3 items-start sm:items-center justify-between mb-4 px-2 sm:px-4 py-2 flex-shrink-0'>
                            <div className='flex flex-wrap gap-2 sm:space-x-3'>
                                {['all', 'COMMUTER', 'DRIVER', 'ADMIN'].map((r) => (
                                    <Button key={r} onClick={() => setFilterRole(r as Role | 'all')} className={`px-2 sm:px-4 py-2 sm:py-5 rounded text-xs sm:text-sm ${filterRole === r ? 'bg-primary text-white' : 'bg-gray-200'}`}>
                                        {r.charAt(0).toUpperCase() + r.slice(1)}
                                    </Button>
                                ))}
                            </div>
                            <Dialog open={openDriverModal} onOpenChange={setOpenDriverModal}>
                                <DialogTrigger asChild>
                                    <Button className='text-background px-2 sm:px-4 py-2 sm:py-5 text-xs sm:text-sm'>
                                        Add Driver <Plus className='w-3 h-3 sm:w-4 sm:h-4 ml-1' />
                                    </Button>
                                </DialogTrigger>
                                <AddDriverModal setOpen={setOpenDriverModal} />
                            </Dialog>
                        </div>

                        <div className='flex-1 min-h-0 overflow-hidden'>
                            <div className='h-full overflow-y-auto' ref={accountRef}>
                                <AccountTable filteredAccounts={filteredAccounts} units={units} assignDriverToUnit={assignDriverToUnit} />
                            </div>
                        </div>
                    </TabsContent>

                    <TabsContent value='Units' className='flex flex-col flex-1 h-0'>
                        <div className='flex flex-col sm:flex-row justify-between items-start sm:items-center mb-4 space-y-3 sm:space-y-0 flex-shrink-0'>
                            <h3 className='text-lg sm:text-xl font-semibold mb-0 sm:mb-3'>Units List</h3>

                            <Dialog open={openUnitModal} onOpenChange={setOpenUnitModal}>
                                <DialogTrigger asChild>
                                    <Button className='text-background px-2 sm:px-4 py-2 sm:py-5 text-xs sm:text-sm'>
                                        Add Unit <Plus className='w-3 h-3 sm:w-4 sm:h-4 ml-1' />
                                    </Button>
                                </DialogTrigger>

                                <AddUnitModal setOpen={setOpenUnitModal} />
                            </Dialog>
                        </div>
                        <div className='flex-1 min-h-0 overflow-hidden'>
                            <div className='h-full overflow-y-auto' ref={unitRef}>
                                <UnitsTable units={units} drivers={accounts} />
                            </div>
                        </div>
                    </TabsContent>
                </Tabs>
            </div>
        </div>
    );
};

export default ManageAccount;
