﻿
&Вместо("ПечатьТоварныйЧек")
Функция УУ_ПечатьТоварныйЧек(МассивОбъектов, ОбъектыПечати)
	// Вариант с расширением макета (в макет добавить пустую строку)
	//Результат = ПродолжитьВызов(МассивОбъектов, ОбъектыПечати); 
	//Для каждого ОбъектПечати из ОбъектыПечати Цикл  
	//	Областьдокумента = Результат.Области.Найти(ОбъектПечати);  
	//	Если НЕ ОбластьДокумента = Неопределено Тогда
	//		КонецОбласти = ОбластьДокумента.Низ;  
	//		Результат.Область(КонецОбласти,2).Текст = ОбъектПечати.Значение.Контрагент;  
	//		Результат.Область(КонецОбласти,2).ВысотаСтроки = 20; 
	//	КонецЕсли;	
	//КонецЦикла;	
	//Результат.АвтоМасштаб = Ложь;   
	//
	//Возврат Результат
	
	 //Вариант без расширения макета, макет можно удалить из расширения
	Результат = ПродолжитьВызов(МассивОбъектов, ОбъектыПечати); 
	ТД = Новый ТабличныйДокумент; 
	ТД.АвтоМасштаб			= Истина;
	ТД.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТД.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_РозничнаяПродажа_ТоварныйЧек";

	ТДОбласть = Новый ТабличныйДокумент;  
	Для каждого ОбъектПечати из ОбъектыПечати Цикл  
		Областьдокумента = Результат.Области.Найти(ОбъектПечати);  
		Если НЕ ОбластьДокумента = Неопределено Тогда
			НомерСтрокиНачало = ТД.ВысотаТаблицы + 1;
			ОбластьДокумента.КонецСтраницы = Ложь;
			ТДОбласть.ВставитьОбласть(Областьдокумента, ТДОбласть.Область());  
			ТД.Вывести(ТДОбласть); 
			ТДОбласть.Очистить();
			ТДОбласть.ВставитьОбласть(Результат.Область("R"+ТД.ВысотаТаблицы+"C1"), ТДОбласть.Область()); 
			Пока ТД.ПроверитьВывод(ТДОбласть) Цикл
				ТД.Вывести(ТДОбласть);
			КонецЦикла;	
			ТДОбласть.Очистить();
			ТД.Область(ТД.ВысотаТаблицы,2).Текст = ОбъектПечати.Значение.Контрагент;  
			ТД.ВывестиГоризонтальныйРазделительСтраниц();
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТД,
			НомерСтрокиНачало, ОбъектыПечати, ОбъектПечати.Значение);
		КонецЕсли;	
	КонецЦикла;	

	Возврат ТД
	
КонецФункции
